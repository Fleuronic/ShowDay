// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Placement

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
		days: [Day],
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		title = day.name
		eventSummaryScreens = day.events
			.map { (day, days, $0, viewItem, showContent) }
			.map(Event.Summary.Screen.init)
	}
}
