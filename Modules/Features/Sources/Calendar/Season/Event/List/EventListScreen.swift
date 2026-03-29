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
		let showContent: (String) -> Void
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
		let showSummary: Bool

		fileprivate let day: Day
		fileprivate let days: [Day]
		fileprivate let event: Event
		fileprivate let viewItem: (Any) -> Void
		fileprivate let showContent: (String) -> Void
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

		let descriptor = list.isHistorical ? "events" : "upcoming events"
		eventCountText = "\(list.content.count) \(descriptor)"
	}
}

extension Event.List.Screen {
	var sections: [Section] {
		let rows = list.content.map { ($0, days, $1, viewItem, showContent) }.map(Row.init)
		let sections = Dictionary(grouping: rows, by: \.sectionName).map(Section.init).sorted()
		return days.areHistorical ? sections.reversed() : sections
	}
}

// MARK: -
extension Event.List.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.days.last == rhs.days.last && lhs.eventCountText == rhs.eventCountText
	}
}

// MARK: -
extension Event.List.Screen.Section {
	var detail: String? {
		"\(rows.count) event\(rows.count == 1 ? "" : "s")"
	}
}

// MARK: -
extension Event.List.Screen.Section: Comparable {
	static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.rows.first! < rhs.rows.first!
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
		self.days = days
		self.event = event
		self.viewItem = viewItem
		self.showContent = showContent

		title = event.displayName
		detail = event.showDisplayName.map { _ in event.location.description }
		subtitle = day.dateString
		sectionName = day.month
		showSummary = !day.isUpcoming
	}

	var summaryScreen: Event.Summary.Screen {
		.init(
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
