// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.Info {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: NSMenuItem

		private var detailItems: [NSMenuItem]
		private var viewDetails: () -> Void
		private var viewLocation: () -> Void

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				font: .systemFont(ofSize: 14, weight: .medium)
			)

			detailItems = screen.details.map { detail in
				.init(
					title: detail,
					font: .systemFont(ofSize: 12),
				)
			}

			viewDetails = screen.viewDetails
			viewLocation = screen.viewLocation

			super.init()

			titleItem.action = #selector(titleSelected)
			titleItem.target = self
			detailItems.forEach { item in
				item.action = #selector(detailSelected)
				item.target = self
			}
		}

		@objc private func titleSelected() {
			viewDetails()
		}

		@objc private func detailSelected() {
			viewLocation()
		}
	}
}

// MARK: -
extension Event.Info.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		titleItem.updateTitle(screen.title)

		if detailItems.count == screen.details.count {
			screen.details.enumerated().forEach { index, detail in
				detailItems[index].updateTitle(detail)
			}
		} else {
			detailItems = screen.details.map { detail in
				.init(
					title: detail,
					font: .systemFont(ofSize: 12),
					action: #selector(detailSelected),
					target: self
				)
			}
		}

		viewDetails = screen.viewDetails
		viewLocation = screen.viewLocation

		return [titleItem] + detailItems
	}
}

// MARK: -
extension Event.Info.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Info.View
}
