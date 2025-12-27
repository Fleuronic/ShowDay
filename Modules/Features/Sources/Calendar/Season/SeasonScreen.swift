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
		let headerScreen: Header.Screen?
		let latestScreen: Latest.Screen?
		let loadContent: () -> Void
		let viewItem: (Any) -> Void
		let showEventList: (Bool) -> Void
		let isShowingEventList: Bool
		let toggleCircuit: (Circuit) -> Void
		let enableAllCircuits: () -> Void
	}
}

// MARK: -
extension Calendar.Season.Screen {
	init(
		days: LoadService.DayLoadResult?,
		circuits: LoadService.CircuitLoadResult?,
		excludedCircuits: Set<Circuit>,
		loadContent: @escaping () -> Void,
		viewItem: @escaping (Any) -> Void,
		showEventList: @escaping (Bool) -> Void,
		isShowingEventList: Bool,
		toggleCircuit: @escaping (Circuit) -> Void,
		enableAllCircuits: @escaping () -> Void
	) {
		self.days = days
		self.circuits = circuits
		self.excludedCircuits = excludedCircuits
		self.loadContent = loadContent
		self.viewItem = viewItem
		self.showEventList = showEventList
		self.isShowingEventList = isShowingEventList
		self.toggleCircuit = toggleCircuit
		self.enableAllCircuits = enableAllCircuits

		switch (days, circuits) {
		case let (.success(days), .success(circuits)):
			headerScreen = .init(
				days: days,
				viewItem: viewItem,
				showEventList: showEventList,
				isShowingEventList: isShowingEventList,
				circuits: circuits,
				excludedCircuits: excludedCircuits,
				toggleCircuit: toggleCircuit,
				enableAllCircuits: enableAllCircuits
			)
			latestScreen = .init(
				days: days.prefix(3),
				viewItem: viewItem
			)
		default:
			headerScreen = nil
			latestScreen = nil
		}
	}
}
