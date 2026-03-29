// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

private import Elements

extension Event.List {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem

		private var sections: [Screen.Section]?
		private var summaryViews: [[Event.Summary.View?]]?
		private var headingItems: [MenuItem]?
		private var eventItems: [[MenuItem]]?
		private var eventSubmenuIndices: [NSMenu: (sectionIndex: Int, rowIndex: Int)] = [:]
		private var screen: Screen
		private var shouldShowContent = false

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			item = .init(
				title: screen.title,
				detail: screen.eventCountText,
				badged: true,
				submenuItems: [.init()],
				shiftDetail: true
			)

			self.screen = screen

			super.init()

			item.submenu?.delegate = self
		}

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			if menu == item.submenu {
				if !shouldShowContent {
					shouldShowContent = true
					screen.showContent(description)
				}
			} else if let indices = eventSubmenuIndices[menu] {
				populateEventSubmenu(sectionIndex: indices.sectionIndex, rowIndex: indices.rowIndex)
			}
		}
	}
}

// MARK: -
extension Event.List.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.title,
				detail: screen.eventCountText
			)

			sections = nil
			summaryViews = nil
			headingItems = nil
			eventItems = nil
			eventSubmenuIndices = [:]
		}

		if shouldShowContent && eventSubmenuIndices.isEmpty {
			let sections = sections ?? screen.sections
			let summaryViews = summaryViews ?? sections.map { .init(repeating: nil, count: $0.rows.count) }
			let headingItems = headingItems ?? sections.map(MenuItem.init)
			let eventItems = eventItems ?? sections.map { $0.rows.map(MenuItem.init) }
			let separatorItems = sections.map { _ in NSMenuItem.separator() }

			var indices: [NSMenu: (sectionIndex: Int, rowIndex: Int)] = [:]
			for sectionIndex in sections.indices {
				for rowIndex in eventItems[sectionIndex].indices {
					let eventItem = eventItems[sectionIndex][rowIndex]
					let submenu = eventItem.submenu ?? .init()
					submenu.delegate = self
					eventItem.submenu = submenu
					indices[submenu] = (sectionIndex: sectionIndex, rowIndex: rowIndex)
				}
			}

			item.update(
				submenuItems: sections.indices.flatMap { index in
					[headingItems[index]] + eventItems[index] + [separatorItems[index]]
				}
			)

			self.sections = sections
			self.eventItems = eventItems
			self.headingItems = headingItems
			self.summaryViews = summaryViews
			self.eventSubmenuIndices = indices
		}

		if let sections, let summaryViews {
			for sectionIndex in sections.indices {
				guard sectionIndex < summaryViews.count else { break }
				for rowIndex in sections[sectionIndex].rows.indices {
					guard let summaryView = summaryViews[sectionIndex][rowIndex] else { continue }
					updateEventItem(at: sectionIndex, rowIndex: rowIndex, with: summaryView)
				}
			}
		}

		shouldShowContent = false

		return [item]
	}
}

// MARK: -
private extension Event.List.View {
	func populateEventSubmenu(sectionIndex: Int, rowIndex: Int) {
		guard let sections else { return }

		let row = sections[sectionIndex].rows[rowIndex]
		if summaryViews?[sectionIndex][rowIndex] == nil {
			let summaryView = Event.Summary.View(screen: row.summaryScreen)
			summaryViews?[sectionIndex][rowIndex] = summaryView
			updateEventItem(at: sectionIndex, rowIndex: rowIndex, with: summaryView)
		}
	}

	func updateEventItem(at sectionIndex: Int, rowIndex: Int, with summaryView: Event.Summary.View) {
		guard let sections, let eventItems else { return }

		let row = sections[sectionIndex].rows[rowIndex]
		let eventItem = eventItems[sectionIndex][rowIndex]
		let items = summaryView.menuItems(with: row.summaryScreen)
		if row.showSummary {
			eventItem.update(submenuItems: items)
		} else {
			let detailItems = items[items.count - 2].submenu!.items
			eventItem.update(submenuItems: detailItems)
		}
	}
}

// MARK: -
extension Event.List.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.List.View
}

// MARK: -
@MainActor
private extension MenuItem {
	convenience init(section: Event.List.Screen.Section) {
		self.init(
			title: section.name,
			badgedDetail: section.detail,
			font: .systemFont(ofSize: 13, weight: .medium)
		)
	}

	convenience init(row: Event.List.Screen.Row) {
		self.init(
			title: row.title,
			detail: row.detail,
			subtitle: row.subtitle,
			width: 440,
			padDetail: true
		)
	}
}
