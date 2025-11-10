// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements

extension Calendar.Season.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let selectCurrentSeason: () -> Void

		init(screen: Screen) {
			selectCurrentSeason = screen.selectCurrentSeason
		}

		@objc private func itemSelected() {
			selectCurrentSeason()
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let titleItem = NSMenuItem(
			title: screen.title,
			submenuItems: [.init()]
		)

		return [titleItem] + additionalItems(
			currentSeasonText: screen.currentSeasonText,
			currentYear: screen.isCurrentYear
		)
	}
}

// MARK: -
private extension Calendar.Season.Selector.View {
	func additionalItems(
		currentSeasonText: String,
		currentYear: Bool
	) -> [NSMenuItem] {
		let items: [NSMenuItem]
		if currentYear {
			items = []
		} else {
			let currentSeasonItem = NSMenuItem(title: currentSeasonText)
			currentSeasonItem.action = #selector(itemSelected)
			currentSeasonItem.target = self
			items = [currentSeasonItem]
		}

		let separatorItem = NSMenuItem.separator()
		return items + [separatorItem]
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Selector.View
}
