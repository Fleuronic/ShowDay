// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Event {
	struct List {
		let content: [(Day, Event)]
	}
}

// MARK: -
extension Event.List {
	init(days: [Day]) {
		content = days.flatMap { day in 
			day.events.map { (day, $0) } 
		}
	}
}
