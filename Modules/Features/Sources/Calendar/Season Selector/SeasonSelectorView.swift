// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements
private import struct DrumCorps.Year

extension Calendar.Season.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: MenuItem
		private let currentSeasonItem: MenuItem
		private let separatorItem = NSMenuItem.separator()

		private var screen: Screen

		init(screen: Screen) {
			titleItem = .init(title: screen.title)

			currentSeasonItem = .init(title: screen.currentSeasonText)
			currentSeasonItem.action = #selector(currentSeasonItemSelected)

			self.screen = screen

			super.init()

			titleItem.update(submenuItems: items(year: screen.year))
			currentSeasonItem.target = self
		}

		@objc private func seasonItemSelected(item: NSMenuItem) {
			let year = item.representedObject as! Year
			screen.selectSeason(year)
		}

		@objc private func currentSeasonItemSelected() {
			screen.selectCurrentSeason()
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			let items = items(year: screen.year)
			titleItem.update(submenuItems: items)
			currentSeasonItem.update(title: screen.currentSeasonText)
		}

		return [
			titleItem,
			screen.currentSeasonText.map { _ in currentSeasonItem },
			separatorItem
		].compactMap(\.self)
	}
}

// MARK: -
private extension Calendar.Season.Selector.View {
	func items(year: Year) -> [NSMenuItem] {
		screen.sections.flatMap { section in
			let items = section.rows.map { item(for: $0, year: year) }
			return items + [.separator()]
		}
	}

	func item(for row: Screen.Section.Row, year: Year) -> NSMenuItem {
		let item = MenuItem(title: row.title)
		switch row.content {
		case .year(year):
			item.state = .on
			item.isEnabled = false
		case let .year(year):
			item.action = #selector(seasonItemSelected)
			item.target = self
			item.representedObject = year
		case let .rows(rows):
			let items = rows.map { self.item(for: $0, year: year) }
			item.update(submenuItems: items)
		}

		return item
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Selector.View
}
