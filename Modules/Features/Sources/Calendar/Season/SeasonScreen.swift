// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import struct DrumCorps.Event
import struct DrumCorps.Day
import struct DrumCorps.Year
import struct DrumCorps.Circuit
import struct DrumCorps.Location
import struct DrumCorps.Venue

public extension Calendar.Season {
	struct Screen {
		let days: LoadService.DayLoadResult?
		let circuits: LoadService.CircuitLoadResult?
		let excludedCircuits: Set<Circuit>
		let loadContent: () -> Void
		let viewItem: (Any) -> Void
		let toggleCircuit: (Circuit) -> Void
		let enableAllCircuits: () -> Void
	}
}

// MARK: -
extension Calendar.Season.Screen {
	var headerScreen: Header.Screen? {
		switch (days, circuits) {
		case let (.success(days), .success(circuits)):
			.init(
				days: days,
				circuits: circuits,
				excludedCircuits: excludedCircuits,
				viewItem: viewItem,
				toggleCircuit: toggleCircuit,
				enableAllCircuits: enableAllCircuits
			)
		default:
			nil
		}
	}

	var latestScreen: Latest.Screen? {
		switch days {
		case let .success(days):
			.init(
				days: days.prefix(3),
				viewItem: viewItem
			)
		default:
			nil
		}
	}
}
