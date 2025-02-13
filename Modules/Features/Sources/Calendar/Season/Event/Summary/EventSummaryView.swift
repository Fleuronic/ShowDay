// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit
import struct DrumCorps.Event
import struct DrumCorps.Placement

extension Event.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let viewDetails: (() -> Void)?
		private let viewLocation: (() -> Void)?
		private let placementSummaryView: Placement.Summary.View
		private let eventResultsView: Event.Results.View
		private let eventDetailsView: Event.Details.View

		init(screen: Screen) {
			viewDetails = screen.viewDetails
			viewLocation = screen.viewLocation
			placementSummaryView = .init(screen: screen.placementSummaryScreen)
			eventResultsView = .init(screen: screen.eventResultsScreen)
			eventDetailsView = .init(screen: screen.eventDetailsScreen)
		}

		@objc private func showSelected() {
			viewDetails?()
		}

		@objc private func locationSelected() {
			viewLocation?()
		}
	}
}

// MARK: -
extension Event.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let headerItems: [NSMenuItem]
		if viewDetails != nil, viewLocation != nil {
			let showItem = NSMenuItem(title: screen.title)
			showItem.action = #selector(showSelected)
			showItem.target = self

			let locationItem = NSMenuItem(title: screen.subtitle, font: .systemFont(ofSize: 12))
			locationItem.action = #selector(locationSelected)
			locationItem.target = self

			headerItems = [showItem, locationItem]
		} else {
			headerItems = []
		}

		let separatorItem = NSMenuItem.separator()
		let resultsItems = eventResultsView.menuItems(with: screen.eventResultsScreen)
		let detailsItems = eventDetailsView.menuItems(with: screen.eventDetailsScreen)
		let placementSummaryItems = placementSummaryView.menuItems(with: screen.placementSummaryScreen)

		return headerItems + placementSummaryItems + resultsItems + detailsItems + [separatorItem]
	}
}

// MARK: -
extension Event.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Event.Summary.View
}
