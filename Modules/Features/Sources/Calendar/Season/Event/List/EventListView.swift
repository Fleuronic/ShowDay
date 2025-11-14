// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.List {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let summaryViews: [[Event.Summary.View]]

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			summaryViews = screen.sections.map { section in
				section.rows.map(\.summaryScreen).map(Event.Summary.View.init)
			}
		}
	}
}

// MARK: -
extension Event.List.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[
			.init(
				title: screen.title,
				detail: screen.eventCountText,
				submenuItems: zip(screen.sections, summaryViews).flatMap(items)
			)
		]
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
