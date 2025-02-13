// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Slot

extension Event.Schedule {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let slotViews: [Slot.View]

		init(screen: Screen) {
			slotViews = screen.slotScreens.map(Slot.View.init)
		}
	}
}

// MARK: -
extension Event.Schedule.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let titleItem = NSMenuItem(
			title: screen.title,
			font: .systemFont(ofSize: 13, weight: .medium),
			enabled: false
		)

		let subtitleItem = NSMenuItem(
			title: screen.subtitle,
			font: .systemFont(ofSize: 12)
		)

		let slotItems = zip(screen.slotScreens, slotViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}

		return [titleItem, subtitleItem] + slotItems + footerItems(for: screen.footer)
	}
}

// MARK: -
private extension Event.Schedule.View {
	func footerItems(for footer: String?) -> [NSMenuItem] {
		footer.map { text in
			[
				.separator(),
				NSMenuItem(
					title: text,
					font: .systemFont(ofSize: 12)
				)
			]			
		} ?? []
	}
}

// MARK: -
extension Event.Schedule.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Schedule.View
}
