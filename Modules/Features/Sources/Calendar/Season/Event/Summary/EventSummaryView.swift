// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit
import struct DrumCorps.Event
import struct DrumCorps.Placement

extension Event.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let eventResultsView: Event.Results.View
		private let eventDetailsView: Event.Details.View
		private let placementSummaryView: Placement.Summary.View
		private let showItem: NSMenuItem
		private let locationItem: NSMenuItem
		private let separatorItem = NSMenuItem.separator()

		private var viewDetails: (() -> Void)?
		private var viewLocation: () -> Void

		init(screen: Screen) {
			eventResultsView = .init(screen: screen.eventResultsScreen)
			eventDetailsView = .init(screen: screen.eventDetailsScreen)
			placementSummaryView = .init(screen: screen.placementSummaryScreen)

			showItem = .init(title: screen.title)
			locationItem = .init(title: screen.subtitle, font: .systemFont(ofSize: 12))
			showItem.action = #selector(showSelected)
			locationItem.action = #selector(locationSelected)

			viewDetails = screen.viewDetails
			viewLocation = screen.viewLocation

			super.init()

			showItem.target = self
			locationItem.target = self
		}

		@objc private func showSelected() {
			viewDetails?()
		}

		@objc private func locationSelected() {
			viewLocation()
		}
	}
}

// MARK: -
extension Event.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		showItem.updateTitle(screen.title)
		locationItem.updateTitle(screen.subtitle)

		let resultsItems = eventResultsView.menuItems(with: screen.eventResultsScreen)
		let detailsItems = eventDetailsView.menuItems(with: screen.eventDetailsScreen)
		let placementSummaryItems = placementSummaryView.menuItems(with: screen.placementSummaryScreen)

		let headerItems = [
			screen.title.map { _ in showItem },
			locationItem
		].compactMap(\.self)

		viewDetails = screen.viewDetails
		viewLocation = screen.viewLocation

		return headerItems + placementSummaryItems + resultsItems + detailsItems + [separatorItem]
	}
}

// MARK: -
extension Event.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Summary.View
}
