// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Division

extension Event.Results {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: NSMenuItem
		private let detailItem: NSMenuItem
		private let circuitItem: NSMenuItem
		private let separatorItem = NSMenuItem.separator()

		private var placementViews: [[Placement.View]]
		private var divisionItems: [[NSMenuItem]]
		private var viewScores: () -> Void

		init(screen: Screen) {
			item = .init(title: screen.title)
			detailItem = .init(
				title: screen.detail,
				font: .systemFont(ofSize: 14, weight: .medium),
			)

			circuitItem = .init(
				title: screen.circuitText,
				font: .systemFont(ofSize: 12)
			)

			placementViews = .init(screen: screen)
			divisionItems = .init(screen: screen)
			viewScores = screen.viewScores

			super.init()

			detailItem.action = #selector(titleSelected)
			detailItem.target = self
		}

		@objc private func titleSelected() {
			viewScores()
		}
	}
}

// MARK: -
extension Event.Results.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		item.updateTitle(screen.title)
		detailItem.updateTitle(screen.detail)
		circuitItem.updateTitle(screen.circuitText)

		if placementViews.map(\.count) != screen.placementScreens.map(\.1.count) {
			placementViews = .init(screen: screen)
			divisionItems = .init(screen: screen)
		}

		if screen.placementScreens.isEmpty {
			item.isEnabled = false
		} else {
			let footerItems = screen.circuitText.map { _ in [separatorItem, circuitItem] } ?? []
			let placementItems: [NSMenuItem] = .init(
				screen: screen,
				divisionItems: divisionItems,
				placementViews: placementViews
			)

			let items = [detailItem] + placementItems + footerItems
			item.isEnabled = true
			item.updateSubmenuItems(items)
		}

		viewScores = screen.viewScores

		return [item]
	}
}

// MARK: -
extension Event.Results.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Results.View
}

// MARK: -
@MainActor
private extension [[Placement.View]] {
	init(screen: Event.Results.Screen) {
		self = screen.placementScreens.map { $0.1.map(Placement.View.init) }
	}
}

// MARK: -
@MainActor
private extension [NSMenuItem] {
	init(
		screen: Event.Results.Screen,
		divisionItems: [[NSMenuItem]],
		placementViews: [[Placement.View]]
	) {
		self = screen.placementScreens.enumerated().flatMap { index, divisionScreens in
			let divisionItems = divisionItems[index]
			let placementViews = placementViews[index]
			let (_, screens) = divisionScreens

			return divisionItems + zip(screens, placementViews).flatMap { screen, view in
				view.menuItems(with: screen)
			}
		}
	}
}

// MARK: -
@MainActor
private extension [[NSMenuItem]] {
	init(screen: Event.Results.Screen) {
		self = screen.placementScreens.map { screen in
			screen.0.map { divisionName in
				[
					.init(
						title: divisionName,
						font: .systemFont(ofSize: 12)
					)
				]
			} ?? []
		}
	}
}
