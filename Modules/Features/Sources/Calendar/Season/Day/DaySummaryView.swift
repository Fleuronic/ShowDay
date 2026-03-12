// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Day.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: NSMenuItem

		private var eventSummaryViews: [Event.Summary.View]

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				font: .systemFont(ofSize: 14, weight: .medium),
				enabled: false
			)

			eventSummaryViews = .init(screen: screen)
		}
	}
}

// MARK: -
extension Day.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		titleItem.updateTitle(screen.title)

		if eventSummaryViews.count != screen.eventSummaryScreens.count {
			eventSummaryViews = .init(screen: screen)
		}

		return [titleItem] + zip(screen.eventSummaryScreens, eventSummaryViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Day.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Day.Summary.View
}

// MARK: -
@MainActor
private extension [Event.Summary.View] {
	init(screen: Day.Summary.Screen) {
		self = screen.eventSummaryScreens.map(Event.Summary.View.init)
	}
}
