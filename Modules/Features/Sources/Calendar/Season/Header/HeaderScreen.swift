// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Year
import struct DrumCorps.Event
import struct DrumCorps.Circuit
import struct DrumCorps.Placement

enum Header {}

// MARK: -
extension Header {
	struct Screen {
		let spanScreen: Span.Screen?
		let eventListScreen: Event.List.Screen?
		let circuitSelectorScreen: Circuit.Selector.Screen?
	}
}

// MARK: -
extension Header.Screen {
	init(
		year: Year,
		days: [Day],
		circuits: [Circuit],
		excludedCircuits: Set<Circuit>,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void,
		toggleCircuit: @escaping (Circuit) -> Void,
		enableAllCircuits: @escaping () -> Void
	) {
		spanScreen = days.isEmpty ? nil : .init(
			days: days,
			year: year
		)

		eventListScreen = days.isEmpty ? nil : .init(
			days: days,
			showContent: showContent,
			viewItem: viewItem
		)

		circuitSelectorScreen = circuits.count < 2 ? nil : .init(
			circuits: circuits,
			excludedCircuits: excludedCircuits,
			toggleCircuit: toggleCircuit,
			enableAllCircuits: enableAllCircuits
		)
	}
}

// MARK: -
extension Header.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.eventListScreen == rhs.eventListScreen
	}
}
