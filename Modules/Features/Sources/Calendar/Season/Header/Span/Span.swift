// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day

struct Span {
	let firstDay: Day 
	let lastDay: Day
	let dayCount: Int

	init(days: [Day]) {
		firstDay = days.last!
		lastDay = days.first!
		dayCount = firstDay.counting(to: lastDay)
	}
}
