// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Day
import struct DrumCorps.Event

extension Placement {
	struct SeasonResults {
		let content: [(Day, Event, Placement)]
		let winCount: Int
		let isUndefeated: Bool
	}
}

extension Placement.SeasonResults {
	init(
		days: [Day],
		placement: Placement
	) {
		content = days.flatMap { day in day.events.map { (day, $0) } }.compactMap { day, event in
			guard let placement = event.placements.flatMap(\.1).first(where: { $0.name == placement.name }) else {
				return nil
			}

			return (day, event, placement)
		}

		winCount = content.count { $0.2.rank == 1 }
		isUndefeated = winCount == content.count && !content.isEmpty
	}
}
