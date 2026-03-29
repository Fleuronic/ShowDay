// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Slot

extension Event {
	enum Summary {}
}

// MARK: -
extension Event.Summary {
	struct Screen {
		let title: String?
		let subtitle: String
		let lineupTitle: String?
		let lineupDetail: String?
		let viewDetails: (() -> Void)?
		let viewLocation: (() -> Void)
		let slotSummaryScreen: Slot.Summary.Screen
		let placementSummaryScreen: Placement.Summary.Screen
		let eventResultsScreen: Event.Results.Screen?
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

		let isExhibition = !day.isUpcoming && event.placements.isEmpty
		lineupTitle = if isExhibition {
			"All corps performed in exhibition"
		} else if event.slots.isEmpty {
			"Performing corps to be determined"
		} else if event.remainingSlotCount > 0 {
			"Full Lineup"
		} else {
			nil
		}

		let action = isExhibition ? "performing" : "competing"
		lineupDetail = if event.remainingSlotCount > 0 {
			"+\(event.remainingSlotCount) more \(action)"
		} else {
			nil
		}

		viewDetails = { viewItem(event) }
		viewLocation = { viewItem(event.venue ?? event.location) }

		slotSummaryScreen = .init(
			slots: event.upcomingSlots,
			viewItem: viewItem
		)

		placementSummaryScreen = .init(
			placements: event.topPlacements,
			event: event,
			days: days,
			viewItem: viewItem,
			showContent: showContent
		)

		eventResultsScreen = day.isUpcoming ? nil : .init(
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

// MARK: -
extension Event.Summary.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.eventDetailsScreen == rhs.eventDetailsScreen
	}
}
