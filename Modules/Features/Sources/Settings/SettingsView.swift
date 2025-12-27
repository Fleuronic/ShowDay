// Copyright © Fleuronic LLC. All rights reserved.

public import AppKit
public import ErgoAppKit

private import Elements

public extension Settings {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: NSMenuItem
		private let quit: () -> Void

		public init(screen: Screen) {
			item = .init(title: "Quit Show Day")
			quit = screen.quit

			super.init()

			item.action = #selector(itemSelected)
			item.target = self
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
		[item]
	}
}

// MARK: -
extension Settings.Screen: @MainActor MenuBackingScreen {
	public typealias View = Settings.View
}
