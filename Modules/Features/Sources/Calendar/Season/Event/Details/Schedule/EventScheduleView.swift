// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Slot

extension Event.Schedule {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: NSMenuItem
		private let subtitleItem: NSMenuItem
		private let separatorItem = NSMenuItem.separator()
		private let footerItem: NSMenuItem

		private var slotViews: [Slot.View]

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				font: .systemFont(ofSize: 13, weight: .medium),
				enabled: false
			)

			subtitleItem = .init(
				title: screen.subtitle,
				font: .systemFont(ofSize: 12)
			)

			footerItem = .init(
				title: screen.footer,
				font: .systemFont(ofSize: 12)
			)

			slotViews = .init(screen: screen)
		}
	}
}

// MARK: -
extension Event.Schedule.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		titleItem.updateTitle(screen.title)
		subtitleItem.updateTitle(screen.subtitle)
		footerItem.updateTitle(screen.footer)

		if slotViews.count != screen.slotScreens.count {
			slotViews = .init(screen: screen)
		}

		let footerItems = screen.footer.map { _ in [separatorItem, footerItem] } ?? []
		let slotItems = zip(screen.slotScreens, slotViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}

		return [titleItem, subtitleItem] + slotItems + footerItems
	}
}

// MARK: -
extension Event.Schedule.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Schedule.View
}

// MARK: -
@MainActor
private extension [Slot.View] {
	init(screen: Event.Schedule.Screen) {
		self = screen.slotScreens.map(Slot.View.init)
	}
}
