// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Placement

extension Event {
	enum Summary {}
}

// MARK: -
extension Event.Summary {
	struct Screen {
		let title: String?
		let subtitle: String
		let viewDetails: (() -> Void)?
		let viewLocation: (() -> Void)
		let placementSummaryScreen: Placement.Summary.Screen
		let eventResultsScreen: Event.Results.Screen
		let eventDetailsScreen: Event.Details.Screen
	}
}

// MARK: -
extension Event.Summary.Screen {
	init(
		day: Day,
		days: [Day],
		event: Event,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		title = event.showName
		subtitle = event.location.description
		viewDetails = { viewItem(event) }
		viewLocation = { viewItem(event.venue ?? event.location) }
		placementSummaryScreen = .init(
			placements: event.topPlacements,
			event: event,
			days: days,
			viewItem: viewItem,
			showContent: showContent
		)

		eventResultsScreen = .init(
			event: event,
			days: days,
			viewItem: viewItem,
			showContent: showContent
		)

		eventDetailsScreen = .init(
			day: day,
			event: event,
			viewItem: viewItem
		)
	}
}
