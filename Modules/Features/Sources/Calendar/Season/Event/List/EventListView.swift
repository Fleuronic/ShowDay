// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.List {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: NSMenuItem

		private var summaryViews: [[Event.Summary.View]]?
		private var eventItems: [[NSMenuItem]]?
		private var eventCountText: String

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			let loadingItem = NSMenuItem(
				title: "Loading…",
				width: 425,
				enabled: false
			)

			item = .init(
				title: screen.title,
				detail: screen.eventCountText,
				submenuItems: [loadingItem]
			)

			eventCountText = screen.eventCountText
		}
	}
}

// MARK: -
extension Event.List.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if eventCountText != screen.eventCountText { // TODO: Not just count but sections
			eventCountText = screen.eventCountText

			item.updateTitle(screen.title)
			item.updateDetail(eventCountText)

			summaryViews = nil
			eventItems = nil
		}

		let summaryViews = summaryViews ?? .init(screen: screen)
		let eventItems = eventItems ?? .init(sections: screen.sections)

		screen.sections.enumerated().forEach { index, section in
			let eventItems = eventItems[index]
			let summaryViews = summaryViews[index]

			(1..<eventItems.count - 1).forEach { index in
				let item = eventItems[index]
				let row = section.rows[index - 1]
				let summaryView = summaryViews[index - 1]
				let items = summaryView.menuItems(with: row.summaryScreen)
				item.updateSubmenuItems(items)
			}
		}

		let items = eventItems.flatMap(\.self)
		item.updateSubmenuItems(items)
		self.summaryViews = summaryViews
		self.eventItems = eventItems

		return [item]
	}
}

// MARK: -
extension Event.List.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.List.View
}

// MARK: -
@MainActor
private extension [[Event.Summary.View]] {
	init(screen: Event.List.Screen) {
		self = screen.sections.map { section in
			section.rows.map(\.summaryScreen).map(Event.Summary.View.init)
		}
	}
}

// MARK: -
@MainActor
private extension [[NSMenuItem]] {
	init(sections: [Event.List.Screen.Section]) {
		self = sections.map { section in
			let items = section.rows.map { row in
				NSMenuItem(
					title: row.title,
					detail: row.detail,
					subtitle: row.subtitle,
					width: 425
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
}
