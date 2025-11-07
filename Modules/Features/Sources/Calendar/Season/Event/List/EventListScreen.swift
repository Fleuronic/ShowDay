// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Event.List {
	struct Screen {
		let title = "Full Calendar"
		let eventCountText: String
		let sections: [Section]
	}
}

// MARK: -
extension Event.List.Screen {
	struct Section {
		let name: String
		let rows: [Row]
	}
	
	struct Row {
		let title: String
		let detail: String?
		let subtitle: String
		let sectionName: String
		let summaryScreen: Event.Summary.Screen

		private let day: Day
	}

	init(
		days: [Day],
		viewItem: @escaping (Any) -> Void
	) {
		let list = Event.List(days: days)
		let content = list.content
		eventCountText = "\(content.count) Events"

		let rows = content.map { ($0, $1, viewItem) }.map(Row.init)
		sections = Dictionary(grouping: rows, by: \.sectionName).map(Section.init).sorted()
		// TODO: More sorting
	}
}

// MARK: -
extension Event.List.Screen.Section: Comparable {
	static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.rows.first! > rhs.rows.first!
	}
}

// MARK: -
extension Event.List.Screen.Row {
	init(
		day: Day,
		event: Event,
		viewItem: @escaping (Any) -> Void
	) {
		self.day = day
		
		title = event.showDisplayName ?? event.location.description
		detail = event.showDisplayName.map { _ in event.location.description }
		subtitle = day.dateString
		sectionName = day.month
		summaryScreen = .init(
			day: day, 
			event: event,
			viewItem: viewItem
		)
	}
}

// MARK: -
extension Event.List.Screen.Row: Comparable {
	static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.day == rhs.day
	}

	static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.day < rhs.day
	}
}
