// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements

extension Calendar.Season.Navigation {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem
		private var screen: Screen

		init(screen: Screen) {
			item = .init(
				title: screen.text,
				font: .systemFont(ofSize: 18, weight: .medium)
			)

			self.screen = screen
		}
	}
}

// MARK: -
extension Calendar.Season.Navigation.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(title: screen.text)
		}

		return [item]
	}
}

// MARK: -
extension Calendar.Season.Navigation.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Navigation.View
}
