// Copyright © Fleuronic LLC. All rights reserved.

public import AppKit
public import ErgoAppKit

public extension Calendar.Season {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let loadDays: () -> Void
		
		private var headerView: Header.View?
		private var latestView: Latest.View? 
		
		public init(screen: Screen) {
			loadDays = screen.loadDays
		}

		// MARK: NSMenuDelegate
		@objc public func menuWillOpen(_ menu: NSMenu) {
			loadDays()
		}
	}
}

// MARK: -
extension Calendar.Season.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let headerScreen = screen.headerScreen
		let latestScreen = screen.latestScreen
		
		headerView = headerScreen.map(Header.View.init) 
		latestView = latestScreen.map(Latest.View.init)

		let separatorItem = NSMenuItem.separator()
		let headerItems = headerScreen.flatMap { headerView?.menuItems(with: $0) } ?? []
		let latestItems = latestScreen.flatMap { latestView?.menuItems(with: $0) } ?? []

		return headerItems + [separatorItem] + latestItems
	}
}

// MARK: -
extension Calendar.Season.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.View
}
