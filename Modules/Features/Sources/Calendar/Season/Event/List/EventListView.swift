// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.List {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let loadingItem: NSMenuItem
		private let showContent: () -> Void

		private var summaryViews: [[Event.Summary.View]]?
		private var item: NSMenuItem
		private var sections: [Event.List.Screen.Section]?
		private var eventCountText: String

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			if sections == nil {
				DispatchQueue.main.async {
					self.showContent()
				}
			}
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			loadingItem = .init(
				title: "Loading…",
				width: 425,
				enabled: false
			)

			showContent = screen.showContent
			item = .init(
				title: screen.title,
				detail: screen.eventCountText
			)

			eventCountText = screen.eventCountText
		}
	}
}

// MARK: -
extension Event.List.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if eventCountText != screen.eventCountText { // TODO: Not just count but sections
			sections = nil
			summaryViews = nil
			eventCountText = screen.eventCountText

			item.updateTitle(screen.title)
			item.updateDetail(eventCountText)
			item.submenu?.items = [loadingItem]
		}

		if let submenu = item.submenu {
			if let sections = screen.sections {
				let summaryViews = summaryViews ?? sections.map { section in
					section.rows.map(\.summaryScreen).map(Event.Summary.View.init)
				}

				submenu.items = zip(sections, summaryViews).flatMap(items)

				self.summaryViews = summaryViews
				self.sections = sections
			}
		} else {
			let submenu = NSMenu()
			submenu.delegate = self
			submenu.items = [loadingItem]
			item.submenu = submenu
		}

		return [item]
	}
}

// MARK: -
private extension Event.List.View {
	func items(for section: Event.List.Screen.Section, with summaryViews: [Event.Summary.View]) -> [NSMenuItem] {
		let items = zip(section.rows, summaryViews).map { row, summaryView in
			NSMenuItem(
				title: row.title,
				detail: row.detail,
				subtitle: row.subtitle,
				width: 425,
				submenuItems: summaryView.menuItems(with: row.summaryScreen)
			)
		}

		let separatorItem = NSMenuItem.separator()
		let headingItem = NSMenuItem(
			title: section.name,
			font: .systemFont(ofSize: 13, weight: .medium),
			enabled: false
		)

		return [headingItem] + items + [separatorItem]
	}
}

// MARK: -
extension Event.List.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.List.View
}
