// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Division

extension Placement {
	struct SeasonResults {
		let content: [(Division?, [(Day, Event, Placement)])]
	}
}

extension Placement.SeasonResults {
	init(
		days: [Day],
		placement: Placement
	) {
		content = Dictionary(
			grouping: days.flatMap { day in day.events.map { (day, $0) } }.compactMap { day, event in
				event.placements.compactMap { pair in
					pair.1.first { $0.name == placement.name }.map {
						(pair.0, day, event, $0)
					}
				}
			}.flatMap { $0 }
		) { $0.0 }.map { division, placements in
			(division, placements.map { ($0.1, $0.2, $0.3) })
		}.sorted { lhs, rhs in
			switch (lhs.0, rhs.0) {
			case let (a?, b?): a < b
			case (_?, nil): true
			default: false
			}
		}
	}
}
