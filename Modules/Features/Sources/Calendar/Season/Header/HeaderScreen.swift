// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Circuit

enum Header {}

// MARK: -
extension Header {
	struct Screen {
		let headingScreen: Heading.Screen
		let spanScreen: Span.Screen
		let eventListScreen: Event.List.Screen
		let circuitSelectorScreen: Circuit.Selector.Screen
	}
}

// MARK: -
extension Header.Screen {
	init(
		days: [Day],
		year: Int
	) {
		headingScreen = Heading.Screen(year: year)
		spanScreen = Span.Screen(days: days)
		eventListScreen = Event.List.Screen(days: days)
		circuitSelectorScreen = Circuit.Selector.Screen()
	}
}
