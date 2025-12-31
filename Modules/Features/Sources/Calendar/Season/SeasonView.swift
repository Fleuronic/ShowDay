// Copyright © Fleuronic LLC. All rights reserved.

public import AppKit
public import ErgoAppKit

public extension Calendar.Season {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let separatorItem = NSMenuItem.separator()
		private let loadingItem: NSMenuItem
		private let loadContent: () -> Void
//		private let hideEventList: () -> Void

		private var headerView: Header.View?
		private var latestView: Latest.View?

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			loadContent()
		}

		public func menuDidClose(_ menu: NSMenu) {
//			hideEventList()
		}

		// MARK: MenuItemDisplaying
		public init(screen: Screen) {
			loadingItem = .init(
				title: "Loading…",
				width: 322,
				enabled: false
			)

			loadContent = screen.loadContent
//			hideEventList = { screen.showContent(false) }
		}
	}
}

// MARK: -
extension Calendar.Season.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		guard
			let headerScreen = screen.headerScreen,
			let latestScreen = screen.latestScreen else {
			return [loadingItem]
		}

		headerView = headerView ?? .init(screen: headerScreen)
		latestView = latestView ?? .init(screen: latestScreen)

		let headerItems = headerView?.menuItems(with: headerScreen) ?? []
		let latestItems = latestView?.menuItems(with: latestScreen) ?? []

		return headerItems + [separatorItem] + latestItems
	}
}

// MARK: -
extension Calendar.Season.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.View
}
