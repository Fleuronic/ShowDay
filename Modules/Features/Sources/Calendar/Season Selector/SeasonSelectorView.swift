// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements
private import struct DrumCorps.Year

extension Calendar.Season.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let selectSeason: (Year) -> Void
		private let selectCurrentSeason: () -> Void

		init(screen: Screen) {
			selectSeason = screen.selectSeason
			selectCurrentSeason = screen.selectCurrentSeason
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
		let titleItem = NSMenuItem(
			title: screen.title,
			submenuItems: items(for: screen.sections, year: screen.year)
		)

		return [titleItem] + additionalItems(for: screen.currentSeasonText)
	}
}

// MARK: -
private extension Calendar.Season.Selector.View {
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

	func items(for sections: [Screen.Section], year: Year) -> [NSMenuItem] {
		sections.flatMap { section in
			let items = section.rows.map { item(for: $0, year: year) }
			let separatorItem = NSMenuItem.separator()
			return items + [separatorItem]
		}
	}

	func additionalItems(for currentSeasonText: String?) -> [NSMenuItem] {
		let items = currentSeasonText.map { text in
			[
				NSMenuItem(
					title: text, 
					action: #selector(currentSeasonItemSelected), 
					target: self
				)
			]
		} ?? []
	
		let separatorItem = NSMenuItem.separator()
		return items + [separatorItem]
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Calendar.Season.Selector.View
}
