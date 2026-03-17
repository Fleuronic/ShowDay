// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

private import Elements

extension Event.Info {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: MenuItem

		private var detailItems: [MenuItem] = []
		private var viewDetails: () -> Void
		private var viewLocation: () -> Void

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				font: .systemFont(ofSize: 14, weight: .medium),
				header: false
			)

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
				MenuItem(
					title: detail,
					font: .systemFont(ofSize: 12),
					header: false,
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
