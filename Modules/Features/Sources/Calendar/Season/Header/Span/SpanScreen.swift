// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Year

extension Span {
	struct Screen {
		let rangeText: String
		let dayCountText: String

		private let year: Year
	}
}

// MARK: -
extension Span.Screen {
	init(
		days: [Day],
		year: Year
	) {
		self.year = year

		let span = Span(days: days)
		rangeText = "\(span.firstDay.monthAndDay) to \(span.lastDay.monthAndDay)"
		dayCountText = "\(span.dayCount) days"
	}
}

// MARK: -
extension Span.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.year == rhs.year && lhs.rangeText == rhs.rangeText
	}
}
