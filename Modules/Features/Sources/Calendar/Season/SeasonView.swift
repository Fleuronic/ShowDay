// Copyright © Fleuronic LLC. All rights reserved.

public import AppKit
public import ErgoAppKit

private import Elements

public extension Calendar.Season {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let separatorItem = NSMenuItem.separator()
		private let loadingItem: MenuItem

		private var headerView: Header.View?
		private var latestView: Latest.View?
		private var screen: Screen

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			screen.loadContent()
		}

		// MARK: MenuItemDisplaying
		public init(screen: Screen) {
			loadingItem = .init(
				title: "Loading…",
				width: 341,
				enabled: false
			)

			self.screen = screen
		}
	}
}

// MARK: -
extension Calendar.Season.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		headerView = headerView ?? screen.headerScreen.map(Header.View.init)
		latestView = latestView ?? screen.latestScreen.map(Latest.View.init)

		if
			let headerScreen = screen.headerScreen,
			let latestScreen = screen.latestScreen {
			let headerItems = headerView?.menuItems(with: headerScreen) ?? []
			let latestItems = latestView?.menuItems(with: latestScreen) ?? []
			return headerItems + [separatorItem] + latestItems
		} else {
			return [loadingItem]
		}
	}
}

// MARK: -
extension Calendar.Season.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.View
}
