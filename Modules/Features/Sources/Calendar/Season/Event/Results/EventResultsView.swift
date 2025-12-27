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
		private var placementItems: [NSMenuItem]
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
			placementItems = .init(screen: screen, views: placementViews)
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
			placementItems = .init(screen: screen, views: placementViews)
		}

		if screen.placementScreens.isEmpty {
			item.isEnabled = false
		} else {
			let footerItems = screen.circuitText.map { _ in [separatorItem, circuitItem] } ?? []
			item.isEnabled = true
			item.submenu = item.submenu ?? .init()
			item.submenu?.items = [detailItem] + placementItems + footerItems
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
	init(screen: Event.Results.Screen, views: [[Placement.View]]) {
		self = zip(screen.placementScreens, views).flatMap { divisionScreens, divisionViews in
			let (divisionName, screens) = divisionScreens
			let divisionItems = divisionName.map { name in
				[
					NSMenuItem(
						title: name,
						font: .systemFont(ofSize: 12)
					)
				]
			} ?? []

			return divisionItems + zip(screens, divisionViews).flatMap { screen, view in
				view.menuItems(with: screen)
			}
		}
	}
}
