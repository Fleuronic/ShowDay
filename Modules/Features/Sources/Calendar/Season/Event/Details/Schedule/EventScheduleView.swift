// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Slot

private import Elements

extension Event.Schedule {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let headerItem: MenuItem
		private let subheaderItem: MenuItem
		private let separatorItem = NSMenuItem.separator()
		private let footerItem: MenuItem

		private var slotViews: [Slot.View]

		init(screen: Screen) {
			headerItem = .init(
				title: screen.title,
				badgedDetail: screen.detail,
				font: .systemFont(ofSize: 13, weight: .medium)
			)

			subheaderItem = .init(
				title: screen.subtitle,
				badgedDetail: screen.countText,
				font: .systemFont(ofSize: 12),
				header: false
			)

			footerItem = .init(
				title: screen.footer,
				font: .systemFont(ofSize: 12),
				header: false
			)

			slotViews = .init(screen: screen)
		}
	}
}

// MARK: -
extension Event.Schedule.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		headerItem.updateTitle(screen.title)
		headerItem.updateDetail(screen.detail)
		subheaderItem.updateTitle(screen.subtitle)
		subheaderItem.updateDetail(screen.countText)
		footerItem.updateTitle(screen.footer)

		if slotViews.count != screen.slotScreens.count {
			slotViews = .init(screen: screen)
		}

		let footerItems = screen.footer.map { _ in [separatorItem, footerItem] } ?? []
		let slotItems = zip(screen.slotScreens, slotViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}

		return [headerItem, subheaderItem] + slotItems + footerItems
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
