

import struct DrumCorps.Day
import struct DrumCorps.Event

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
		days: ArraySlice<Day>,
		viewItem: @escaping (Any) -> Void
	) {
		daySummaryScreens = days
			.map { ($0, viewItem) }
			.map(Day.Summary.Screen.init)
	}
}
