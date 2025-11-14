// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements

extension Calendar.Season.Navigation {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		init(screen: Screen) {}
	}
}

// MARK: -
extension Calendar.Season.Navigation.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[
			.init(
				title: screen.text,
				font: .systemFont(ofSize: 18, weight: .medium),
				width: 384,
				enabled: false
			)
		]
	}
}

// MARK: -
extension Calendar.Season.Navigation.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Navigation.View
}
