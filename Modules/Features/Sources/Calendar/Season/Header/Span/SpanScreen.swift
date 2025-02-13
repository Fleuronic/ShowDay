// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day

extension Span {
	struct Screen {
		let rangeText: String
		let dayCountText: String
	}
}

// MARK: -
extension Span.Screen {
	init(days: [Day]) {
		let span = Span(days: days)
		rangeText = "\(span.firstDay.monthAndDay) to \(span.lastDay.monthAndDay)"
		dayCountText = "\(span.dayCount) Days"
	}
}
