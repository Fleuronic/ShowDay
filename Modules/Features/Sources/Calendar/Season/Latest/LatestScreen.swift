// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Placement

enum Latest {}

// MARK: -
extension Latest {
	struct Screen {
		let daySummaryScreens: [Day.Summary.Screen]
	}
}

// MARK: -
extension Latest.Screen {
	init(
		days: [Day],
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		daySummaryScreens = days.prefix(3)
			.map { ($0, .init(days), viewItem, showContent) }
			.map(Day.Summary.Screen.init)
	}
}
