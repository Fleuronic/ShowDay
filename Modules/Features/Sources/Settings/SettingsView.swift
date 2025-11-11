// Copyright © Fleuronic LLC. All rights reserved.

public import AppKit
public import ErgoAppKit

public extension Settings {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let quit: () -> Void

		public init(screen: Screen) {
			quit = screen.quit
		}

		@objc private func itemSelected() {
			quit()
		}
	}
}

// MARK: -
extension Settings.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let quitItem = NSMenuItem(title: "Quit Show Day")
		quitItem.action = #selector(itemSelected)
		quitItem.target = self

		return [quitItem]
	}
}

// MARK: -
extension Settings.Screen: @MainActor MenuBackingScreen {
	public typealias View = Settings.View
}
