// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Circuit

extension Header {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let spanView: Span.View
		private let eventListView: Event.List.View
		private let circuitSelectorView: Circuit.Selector.View

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			spanView = .init(screen: screen.spanScreen)
			eventListView = .init(screen: screen.eventListScreen)
			circuitSelectorView = .init(screen: screen.circuitSelectorScreen)
		}
	}
}

// MARK: -
extension Header.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let spanItems = spanView.menuItems(with: screen.spanScreen)
		let eventListItems = eventListView.menuItems(with: screen.eventListScreen)
		let circuitSelectorItems = circuitSelectorView.menuItems(with: screen.circuitSelectorScreen)
		return spanItems + eventListItems + circuitSelectorItems
	}
}

// MARK: -
extension Header.Screen: @MainActor MenuBackingScreen {
	public typealias View = Header.View
}
