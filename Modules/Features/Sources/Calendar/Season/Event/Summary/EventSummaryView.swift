// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit
import struct DrumCorps.Event
import struct DrumCorps.Slot
import struct DrumCorps.Placement

private import Elements

extension Event.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let eventDetailsView: Event.Details.View
		private let placementSummaryView: Placement.Summary.View
		private let showItem: MenuItem
		private let locationItem: MenuItem
		private let lineupItem: MenuItem
		private let separatorItem = NSMenuItem.separator()

		private var slotSummaryView: Slot.Summary.View?
		private var eventResultsView: Event.Results.View?
		private var screen: Screen

		init(screen: Screen) {
			eventDetailsView = .init(screen: screen.eventDetailsScreen)
			placementSummaryView = .init(screen: screen.placementSummaryScreen)

			showItem = .init(title: screen.title)
			locationItem = .init(
				title: screen.subtitle,
				font: .systemFont(ofSize: 12),
				header: false
			)

			lineupItem = .init(
				title: screen.lineupTitle,
				detail: screen.lineupDetail,
				enabled: false,
				badged: true
			)

			showItem.action = #selector(showSelected)
			locationItem.action = #selector(locationSelected)

			self.screen = screen

			super.init()

			showItem.target = self
			locationItem.target = self
		}

		@objc private func showSelected() {
			screen.viewDetails?()
		}

		@objc private func locationSelected() {
			screen.viewLocation()
		}
	}
}

// MARK: -
extension Event.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			showItem.update(title: screen.title)
			locationItem.update(title: screen.subtitle)

			lineupItem.update(
				title: screen.lineupTitle,
				detail: screen.lineupDetail
			)
		}

		let summaryItems: [NSMenuItem]
		let resultsItems: [NSMenuItem]
		let overflowItems: [NSMenuItem]
		let headerItems = [screen.title.map { _ in showItem }, locationItem ].compactMap(\.self)
		let detailsItems = eventDetailsView.menuItems(with: screen.eventDetailsScreen)

		if let eventResultsScreen = screen.eventResultsScreen {
			let eventResultsView = eventResultsView ?? .init(screen: eventResultsScreen)
			resultsItems = eventResultsView.menuItems(with: eventResultsScreen)
			self.eventResultsView = eventResultsView

			overflowItems = []
			slotSummaryView = nil
			summaryItems = placementSummaryView.menuItems(with: screen.placementSummaryScreen)
		} else {
			let slotSummaryView = slotSummaryView ?? .init(screen: screen.slotSummaryScreen)
			summaryItems = slotSummaryView.menuItems(with: screen.slotSummaryScreen)
			self.slotSummaryView = slotSummaryView

			resultsItems = []
			eventResultsView = nil
			overflowItems = screen.lineupTitle.map { _ in [lineupItem] } ?? []
		}

		let items = headerItems + summaryItems + resultsItems + overflowItems + detailsItems
		return items + [separatorItem]
	}
}

// MARK: -
extension Event.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Summary.View
}
