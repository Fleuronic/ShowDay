// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Circuit

extension Header {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let spanView: Span.View?
		private let eventListView: Event.List.View?
		private let circuitSelectorView: Circuit.Selector.View?

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			spanView = screen.spanScreen.map(Span.View.init)
			eventListView = screen.eventListScreen.map(Event.List.View.init)
			circuitSelectorView = screen.circuitSelectorScreen.map(Circuit.Selector.View.init)
		}
	}
}

// MARK: -
extension Header.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let spanItems = screen.spanScreen.flatMap { spanView?.menuItems(with: $0) } ?? []
		let eventListItems = screen.eventListScreen.flatMap { eventListView?.menuItems(with: $0) } ?? []
		let circuitSelectorItems = screen.circuitSelectorScreen.flatMap { circuitSelectorView?.menuItems(with: $0) } ?? []
		return spanItems + eventListItems + circuitSelectorItems
	}
}

// MARK: -
extension Header.Screen: @MainActor MenuBackingScreen {
	public typealias View = Header.View
}
