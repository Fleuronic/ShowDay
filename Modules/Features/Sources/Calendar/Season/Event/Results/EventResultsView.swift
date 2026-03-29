// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Division

private import Elements

extension Event.Results {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem
		private let detailItem: MenuItem
		private let separatorItem = NSMenuItem.separator()

		private var placementViews: [[Placement.View]]
		private var divisionItems: [[MenuItem]]
		private var circuitItem: MenuItem?
		private var screen: Screen

		init(screen: Screen) {
			item = .init(
				title: screen.title,
				detail: screen.detail,
				badged: true
			)

			detailItem = .init(
				title: screen.header,
				font: .systemFont(ofSize: 14, weight: .medium)
			)

			circuitItem = screen.circuitText.map {
				.init(
					title: $0,
					font: .systemFont(ofSize: 12),
					header: false
				)
			}

			placementViews = screen.placementScreens.map { $0.1.map(Placement.View.init) }
			divisionItems = .init(placementScreens: screen.placementScreens)
			self.screen = screen

			super.init()

			detailItem.action = #selector(titleSelected)
			detailItem.target = self
		}

		@objc private func titleSelected() {
			screen.viewScores()
		}
	}
}

// MARK: -
extension Event.Results.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.title,
				detail: screen.detail
			)

			detailItem.update(title: screen.header)

			if let circuitText = screen.circuitText {
				if let circuitItem = circuitItem {
					circuitItem.update(title: circuitText)
				} else {
					circuitItem = .init(
						title: circuitText,
						font: .systemFont(ofSize: 12),
						header: false
					)
				}
			} else {
				circuitItem = nil
			}

			let divisionDiff = divisionItems.count - screen.placementScreens.count
			if divisionDiff > 0 {
				placementViews.removeLast(divisionDiff)
				divisionItems.removeLast(divisionDiff)
			} else if divisionDiff < 0 {
				placementViews += screen.placementScreens.suffix(-divisionDiff).map { $0.1.map(Placement.View.init) }
				divisionItems += .init(placementScreens: screen.placementScreens.suffix(-divisionDiff))
			}

			for (index, screens) in screen.placementScreens.enumerated() {
				if let (divisionName, divisionDetail) = screens.0, let item = divisionItems[index].first {
					item.update(
						title: divisionName,
						detail: divisionDetail
					)
				}

				let placementDiff = placementViews[index].count - screens.1.count
				if placementDiff > 0 {
					placementViews[index].removeLast(placementDiff)
				} else if placementDiff < 0 {
					placementViews[index] += screens.1.suffix(-placementDiff).map(Placement.View.init)
				}
			}
		}

		if screen.placementScreens.isEmpty {
			item.isEnabled = false
		} else {
			let footerItems = circuitItem.map { [separatorItem, $0] } ?? []
			let placementItems = screen.placementScreens.enumerated().flatMap { index, divisionScreens in
				let divisionItems = divisionItems[index]
				let placementViews = placementViews[index]
				let (_, screens) = divisionScreens

				return divisionItems + zip(screens, placementViews).flatMap { screen, view in
					view.menuItems(with: screen)
				}
			}

			let items = [detailItem] + placementItems + footerItems
			item.isEnabled = true
			item.update(submenuItems: items)
		}

		return [item]
	}
}

// MARK: -
extension Event.Results.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Results.View
}

@MainActor
// TODO
extension [[MenuItem]] {
	init(placementScreens: [((String, String)?, [Placement.Screen])]) {
		self = placementScreens.map { screens in
			screens.0.map { title, detail in
				[
					.init(
						title: title,
						badgedDetail: detail,
						font: .systemFont(ofSize: 12)
					)
				]
			} ?? []
		}
	}
}
