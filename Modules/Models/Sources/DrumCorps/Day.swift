// // Copyright © Fleuronic LLC. All rights reserved.

public import Foundation

private import MemberwiseInit

@MemberwiseInit(.public)
public struct Day {
	public let date: Date
	public let events: [Event]
}

// MARK: -
public extension Day {
	var name: String {
		date.formatted(date: .complete, time: .omitted)
	}

	var dateString: String {
		date.formatted(.dateTime.day().month(.defaultDigits))
	}

	var month: String {
		date.formatted(.dateTime.month(.wide))
	}

	var monthAndDay: String {
		date.formatted(.dateTime.month(.wide).day())
	}

	var year: String {
		date.formatted(.dateTime.year())
	}

	var isUpcoming: Bool {
		date > .init()
	}

	var countingFromToday: Int {
		let calendar = Calendar.current
		let start = calendar.startOfDay(for: .init())
		let end = calendar.startOfDay(for: date)
		let components = calendar.dateComponents([.day], from: start, to: end)
		return components.day ?? 0
	}

	var daysAgoDetail: String {
		let calendar = Calendar.current
		let start = calendar.startOfDay(for: date)
		let end = calendar.startOfDay(for: .init())
		let components = calendar.dateComponents([.year, .day], from: start, to: end)
		let years = components.year ?? 0
		let days = components.day ?? 0

		if years > 0 {
			let yearPart = years == 1 ? "1 year" : "\(years) years"
			if days > 0 {
				let dayPart = days == 1 ? "1 day" : "\(days) days"
				return "\(yearPart), \(dayPart) ago"
			} else {
				return "\(yearPart) ago"
			}
		} else {
			return "\(days) days ago"
		}
	}

	func counting(to day: Self) -> Int {
		let calendar = Calendar.current
		let start = calendar.startOfDay(for: date)
		let end = calendar.startOfDay(for: day.date)
		let components = calendar.dateComponents([.day], from: start, to: end)
		return components.day! + 1
	}
}

extension Day: Comparable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.date == rhs.date
	}

	public static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.date < rhs.date
	}
}

public extension [Day] {
	var areHistorical: Bool {
		self.max().map { $0.date < .init() } ?? false
	}
}
