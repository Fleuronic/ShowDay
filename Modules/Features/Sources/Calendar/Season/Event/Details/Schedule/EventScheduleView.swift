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

		private var slotViews: [Slot.View]
		private var footerItem: MenuItem?
		private var screen: Screen

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

			footerItem = screen.footer.map {
				.init(
					title: $0,
					font: .systemFont(ofSize: 12),
					header: false
				)
			}

			slotViews = screen.slotScreens.map(Slot.View.init)

			self.screen = screen
		}
	}
}

// MARK: -
extension Event.Schedule.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			headerItem.update(
				title: screen.title,
				detail: screen.detail
			)

			subheaderItem.update(
				title: screen.subtitle,
				detail: screen.countText
			)

			if let footer = screen.footer {
				if let footerItem {
					footerItem.update(title: footer)
				} else {
					footerItem = .init(
						title: footer,
						font: .systemFont(ofSize: 12),
						header: false
					)
				}
			} else {
				footerItem = nil
			}

			let diff = slotViews.count - screen.slotScreens.count
			if diff > 0 {
				slotViews.removeLast(diff)
			} else if diff < 0 {
				slotViews += screen.slotScreens.suffix(-diff).map(Slot.View.init)
			}
		}

		let footerItems = footerItem.map { [separatorItem, $0] } ?? []
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
