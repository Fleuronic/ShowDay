// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event

extension Event {
	enum Details {}
}

// MARK: -
extension Event.Details {
	struct Screen {
		let infoScreen: Event.Info.Screen
		let scheduleScreen: Event.Schedule.Screen
	}
}

// MARK: -
extension Event.Details.Screen {
	init(
		day: Day,
		event: Event,
		viewItem: @escaping (Any) -> Void
	) {
		infoScreen = .init(event: event, viewItem: viewItem)
		scheduleScreen = .init(
			day: day, 
			slots: event.slots, 
			circuit: event.circuit,
			viewItem: viewItem
		)
	}
}
