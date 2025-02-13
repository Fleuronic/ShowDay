// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Day {
	enum Summary {}
}

// MARK: -
extension Day.Summary {
	struct Screen {
		let title: String
		let eventSummaryScreens: [Event.Summary.Screen]
	}
}

// MARK: -
extension Day.Summary.Screen {
	init(
		day: Day,
		viewItem: @escaping (Any) -> Void
	) {
		title = day.name
		eventSummaryScreens = day.events
			.map { (day, $0, viewItem) }
			.map(Event.Summary.Screen.init)
	}
}
