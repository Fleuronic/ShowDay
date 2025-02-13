// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.Details {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let infoView: Event.Info.View
		private let scheduleView: Event.Schedule.View

		init(screen: Screen) {
			infoView = .init(screen: screen.infoScreen)
			scheduleView = .init(screen: screen.scheduleScreen)
		}
	}
}

// MARK: -
extension Event.Details.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let infoItems = infoView.menuItems(with: screen.infoScreen)
		let scheduleItems = scheduleView.menuItems(with: screen.scheduleScreen)
		let separatorItem = NSMenuItem.separator()

		return [
			.init(
				title: "Event Details", 
				submenuItems: infoItems + [separatorItem] + scheduleItems
			)
		]
	}
}

// MARK: -
extension Event.Details.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Details.View
}
