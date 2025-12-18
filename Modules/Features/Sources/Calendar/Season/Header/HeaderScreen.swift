// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Circuit

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
		days: [Day],
		circuits: [Circuit],
		excludedCircuits: Set<Circuit>,
		viewItem: @escaping (Any) -> Void,
		toggleCircuit: @escaping (Circuit) -> Void,
		enableAllCircuits: @escaping () -> Void
	) {
		spanScreen = days.isEmpty ? nil : .init(days: days)
		eventListScreen = days.isEmpty ? nil : .init(
			days: days,
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
