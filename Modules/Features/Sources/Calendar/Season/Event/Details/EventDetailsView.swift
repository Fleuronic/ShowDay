// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

private import Elements

extension Event.Details {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let infoView: Event.Info.View
		private let scheduleView: Event.Schedule.View
		private let item: MenuItem
		private let separatorItem = NSMenuItem.separator()

		init(screen: Screen) {
			infoView = .init(screen: screen.infoScreen)
			scheduleView = .init(screen: screen.scheduleScreen)
			item = .init(title: "Event Details")
		}
	}
}

// MARK: -
extension Event.Details.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let infoItems = infoView.menuItems(with: screen.infoScreen)
		let scheduleItems = scheduleView.menuItems(with: screen.scheduleScreen)
		let items = infoItems + [separatorItem] + scheduleItems
		item.update(submenuItems: items)
		return [item]
	}
}

// MARK: -
extension Event.Details.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Details.View
}

