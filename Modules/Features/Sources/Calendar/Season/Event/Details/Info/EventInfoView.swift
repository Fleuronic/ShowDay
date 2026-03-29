// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Event

private import Elements

extension Event.Info {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: MenuItem
		private let addressItem: MenuItem

		private var screen: Screen
		private var venueItem: MenuItem?

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				font: .systemFont(ofSize: 14, weight: .medium),
				header: false
			)

			let title = Self.addressTitle(for: screen)
			let detail = Self.addressDetail(for: screen)
			addressItem = .init(
				title: title,
				stackedDetail: detail,
				font: .systemFont(ofSize: 12),
				header: false,
			)

			let venueTitle = Self.venueTitle(for: screen)
			let venueDetail = Self.venueDetail(for: screen)
			venueItem = venueTitle.map { title in
				.init(
					title: title,
					stackedDetail: venueDetail,
					font: .systemFont(ofSize: 12),
					header: false
				)
			}

			self.screen = screen

			super.init()

			titleItem.action = #selector(titleSelected)
			titleItem.target = self

			addressItem.action = #selector(detailSelected)
			addressItem.target = self

			venueItem?.action = #selector(detailSelected)
			venueItem?.target = self
		}

		@objc private func titleSelected() {
			screen.viewDetails()
		}

		@objc private func detailSelected() {
			screen.viewLocation()
		}
	}
}

// MARK: -
extension Event.Info.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			titleItem.update(title: screen.title)

			let addressTitle = Self.addressTitle(for: screen)
			let addressDetail = Self.addressDetail(for: screen)
			addressItem.update(
				title: addressTitle,
				detail: addressDetail
			)

			if let venueTitle = Self.venueTitle(for: screen) {
				let venueDetail = Self.venueDetail(for: screen)
				if let venueItem = venueItem {
					venueItem.update(
						title: venueTitle,
						detail: venueDetail
					)
				} else {
					let venueItem = MenuItem(
						title: venueTitle,
						stackedDetail: venueDetail,
						font: .systemFont(ofSize: 12),
						header: false
					)

					venueItem.action = #selector(detailSelected)
					venueItem.target = self
					self.venueItem = venueItem
				}
			} else {
				venueItem = nil
			}
		}

		return [titleItem] + [venueItem, addressItem].compactMap { $0 }
	}
}

private extension Event.Info.View {
	static func addressTitle(for screen: Screen) -> String {
		guard
			case let details = screen.details,
			case let count = details.count,
			count > 1 else { return screen.details[0] }

		return count == 4 ? details[2] : details[1]
	}

	static func addressDetail(for screen: Screen) -> String? {
		guard
			case let details = screen.details,
			case let count = details.count,
			count > 1 else { return nil }

		return count == 4 ? details[3] : details[2]
	}

	static func venueTitle(for screen: Screen) -> String? {
		guard
			case let details = screen.details,
			case let count = details.count,
			count > 1 else { return nil }

		return details[0]
	}

	static func venueDetail(for screen: Screen) -> String? {
		guard
			case let details = screen.details,
			case let count = details.count,
			count > 1 else { return nil }

		return count == 4 ? details[1] : nil
	}
}

// MARK: -
extension Event.Info.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Info.View
}
