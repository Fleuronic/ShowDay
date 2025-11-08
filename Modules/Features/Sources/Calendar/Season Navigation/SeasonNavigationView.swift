// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

extension Season.Navigation {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		init(screen: Screen) {}
	}
}

// MARK: -
extension Season.Navigation.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[
			.init(
				title: screen.text,
				font: .systemFont(ofSize: 18, weight: .medium),
				enabled: false
			)
		]
	}
}

// MARK: -
extension Season.Navigation.Screen: @MainActor MenuBackingScreen {
	public typealias View = Season.Navigation.View
}
