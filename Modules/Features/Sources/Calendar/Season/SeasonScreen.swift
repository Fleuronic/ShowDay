// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import struct DrumCorps.Event
import struct DrumCorps.Day
import struct DrumCorps.Circuit
import struct DrumCorps.Location
import struct DrumCorps.Venue

public extension Calendar.Season {
	struct Screen {
		let year: Int
		let days: LoadService.DayLoadResult
		let isLoadingDays: Bool
		let loadDays: () -> Void
		let viewItem: (Any) -> Void
	}
}

// MARK: -
extension Calendar.Season.Screen {
	var headerScreen: Header.Screen? {
		loadedDays
			.map { ($0, year, viewItem) }
			.map(Header.Screen.init)
	}

	var latestScreen: Latest.Screen? {
		loadedDays
			.map { ($0.prefix(3), viewItem) }
			.map(Latest.Screen.init)
	}
}

// MARK: -
private extension Calendar.Season.Screen {
	var loadedDays: [Day]? {
		switch days {
		case .success(let days) where !days.isEmpty: days
		default: nil
		}
	}
}
