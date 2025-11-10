// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Division

extension Event.Results {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let placementViews: [[Placement.View]]
		private let viewScores: () -> Void

		init(screen: Screen) {
			placementViews = screen.placementScreens.map { $0.1.map(Placement.View.init) }
			viewScores = screen.viewScores
		}

		@objc private func titleSelected() {
			viewScores()
		}
	}
}

// MARK: -
extension Event.Results.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let item: NSMenuItem
		if screen.placementScreens.isEmpty {
			item = .init(title: screen.title)
			item.isEnabled = false
		} else {
			let placementItems = zip(screen.placementScreens, placementViews).flatMap(items)
			let detailItem = detailItem(for: screen.detail)
			let footerItems = footerItems(for: screen.circuitText)
			
			item = .init(
				title: screen.title,
				submenuItems: [detailItem] + placementItems + footerItems
			)
		}

		return [item]
	}
}

// MARK: -
private extension Event.Results.View {
	func detailItem(for detail: String) -> NSMenuItem {
		let item = NSMenuItem(
			title: detail,
			font: .systemFont(ofSize: 14, weight: .medium),
		)

		item.action = #selector(titleSelected)
		item.target = self

		return item
	}

	func footerItems(for circuitText: String?) -> [NSMenuItem] {
		let separatorItem = NSMenuItem.separator()
		return circuitText.map { text in
			[
				separatorItem, .init(
					title: text,
					font: .systemFont(ofSize: 12)
				)
			]
		} ?? []
	}

	func items(for divisionNameScreens: (String?, [Placement.Screen]), views: [Placement.View]) -> [NSMenuItem] {
		let (divisionName, screens) = divisionNameScreens
		let divisionItems = divisionName.map { name in
			[
				NSMenuItem(
					title: name, 
					font: .systemFont(ofSize: 12)
				)
			]
		} ?? []
			
		return divisionItems + zip(screens, views).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Event.Results.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Results.View
}
