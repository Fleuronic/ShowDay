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
		viewItem: @escaping (Any) -> Void,
		showEventList: @escaping (Bool) -> Void,
		isShowingEventList: Bool,
		circuits: [Circuit],
		excludedCircuits: Set<Circuit>,
		toggleCircuit: @escaping (Circuit) -> Void,
		enableAllCircuits: @escaping () -> Void,
	) {
		spanScreen = days.isEmpty ? nil : .init(days: days)
		eventListScreen = days.isEmpty ? nil : .init(
			days: days,
			showContent: { showEventList(true) },
			isShowingContent: isShowingEventList,
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
