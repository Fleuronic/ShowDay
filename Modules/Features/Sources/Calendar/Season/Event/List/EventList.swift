// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Event {
	struct List {
		let content: [(Day, Event)]
		let isHistorical: Bool
	}
}

// MARK: -
extension Event.List {
	init(days: [Day]) {
		let content = days.flatMap { day in
			day.events.map { (day, $0) }
		}

		isHistorical = days.areHistorical
		self.content = isHistorical ? content : content.reversed()
	}
}
