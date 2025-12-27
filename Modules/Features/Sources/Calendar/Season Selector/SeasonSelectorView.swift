// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements
private import struct DrumCorps.Year

extension Calendar.Season.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: NSMenuItem
		private let currentSeasonItem: NSMenuItem
		private let separatorItem = NSMenuItem.separator()
		private let selectSeason: (Year) -> Void
		private let selectCurrentSeason: () -> Void

		private var year: Year?

		init(screen: Screen) {
			titleItem = .init(title: screen.title)
			titleItem.submenu = .init()
			currentSeasonItem = .init(title: screen.currentSeasonText)
			currentSeasonItem.action = #selector(currentSeasonItemSelected)

			selectSeason = screen.selectSeason
			selectCurrentSeason = screen.selectCurrentSeason

			super.init()

			currentSeasonItem.target = self
		}

		@objc private func seasonItemSelected(item: NSMenuItem) {
			let year = item.representedObject as! Year
			selectSeason(year)
		}

		@objc private func currentSeasonItemSelected() {
			selectCurrentSeason()
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.View: @MainActor MenuItemDisplaying {
	// MARK: MenuItemDisplaying
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if year != screen.year {
			year = screen.year
			titleItem.submenu?.items = items(for: screen.sections, year: screen.year)
		}

		currentSeasonItem.updateTitle(screen.currentSeasonText)

		return [
			titleItem,
			screen.currentSeasonText.map { _ in currentSeasonItem },
			separatorItem
		].compactMap(\.self)
	}
}

// MARK: -
private extension Calendar.Season.Selector.View {
	func items(for sections: [Screen.Section], year: Year) -> [NSMenuItem] {
		sections.flatMap { section in
			let items = section.rows.map { item(for: $0, year: year) }
			return items + [.separator()]
		}
	}

	func item(for row: Screen.Section.Row, year: Year) -> NSMenuItem {
		let item = NSMenuItem(title: row.title)
		switch row.content {
		case .year(year):
			item.state = .on
			item.isEnabled = false
		case let .year(year):
			item.action = #selector(seasonItemSelected)
			item.target = self
			item.representedObject = year
		case let .rows(rows):
			let submenu = NSMenu()
			submenu.items = rows.map { self.item(for: $0, year: year) }
			item.submenu = submenu
		}

		return item
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Selector.View
}
