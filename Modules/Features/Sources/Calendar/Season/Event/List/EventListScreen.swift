// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Placement

extension Event.List {
	struct Screen {
		let list: Event.List
		let days: [Day]
		let title = "Full Calendar"
		let eventCountText: String
		let viewItem: (Any) -> Void

		private let showContent: (String) -> Void
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
		showContent: @escaping (String) -> Void,
		viewItem: @escaping (Any) -> Void
	) {
		self.days = days
		self.showContent = showContent
		self.viewItem = viewItem

		list = .init(days: days)
		eventCountText = "\(list.content.count) Events"
	}

	var sections: [Section] {
		let rows = list.content.map { ($0, days, $1, viewItem, showContent) }.map(Row.init)
		return Dictionary(grouping: rows, by: \.sectionName).map(Section.init).sorted()
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
		days: [Day],
		event: Event,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		self.day = day

		title = event.displayName
		detail = event.showDisplayName.map { _ in event.location.description }
		subtitle = day.dateString
		sectionName = day.month
		summaryScreen = .init(
			day: day,
			days: days,
			event: event,
			viewItem: viewItem,
			showContent: showContent
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
