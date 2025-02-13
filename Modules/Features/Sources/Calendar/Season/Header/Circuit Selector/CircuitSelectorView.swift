// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Circuit

extension Circuit.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		// MARK: MenuItemDisplaying
		init(screen: Screen) {}
	}
}

// MARK: -
extension Circuit.Selector.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[
			.init(
				title: screen.title, 
				detail: screen.circuitSelectionText,
				submenuItems: [.init()]
			)
		]
	}
}

// MARK: -
extension Circuit.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Circuit.Selector.View
}
