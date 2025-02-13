// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event.Info {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let viewDetails: () -> Void
		private let viewLocation: () -> Void

		init(screen: Screen) {
			viewDetails = screen.viewDetails
			viewLocation = screen.viewLocation
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
		let titleItem = NSMenuItem(
			title: screen.title,
			font: .systemFont(ofSize: 14, weight: .medium)
		)

		titleItem.action = #selector(titleSelected)
		titleItem.target = self
		
		let detailItems = screen.details.map { detail in
			let item = NSMenuItem(
				title: detail,
				font: .systemFont(ofSize: 12),
			)

			item.action = #selector(detailSelected)
			item.target = self
			
			return item
		}
		
		return [titleItem] + detailItems
	}
}

// MARK: -
extension Event.Info.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Info.View
}
