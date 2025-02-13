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

	func counting(to day: Self) -> Int {
		let calendar = Calendar.current
		let start = calendar.startOfDay(for: date)
		let end = calendar.startOfDay(for: day.date)
		let components = calendar.dateComponents([.day], from: start, to: end)
		return components.day ?? 0
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
