// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Day.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let eventSummaryViews: [Event.Summary.View]

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			eventSummaryViews = screen.eventSummaryScreens.map(Event.Summary.View.init)
		}
	}
}

// MARK: -
extension Day.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let titleItem = NSMenuItem(
			title: screen.title,
			font: .systemFont(ofSize: 14, weight: .medium),
			enabled: false
		)

		let eventSummaryItems = zip(screen.eventSummaryScreens, eventSummaryViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}

		return [titleItem] + eventSummaryItems
	}
}

// MARK: -
extension Day.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Day.Summary.View
}
