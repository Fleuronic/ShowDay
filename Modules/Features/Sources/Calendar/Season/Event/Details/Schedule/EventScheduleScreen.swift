// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Day
import struct DrumCorps.Event
import struct DrumCorps.Slot
import struct DrumCorps.Circuit

private import Foundation

extension Event {
	enum Schedule {}
}

// MARK: -
extension Event.Schedule {
	struct Screen {
		let title: String
		let subtitle: String
		let footer: String?
		let slotScreens: [Slot.Screen]
	}
}

// MARK: -
extension Event.Schedule.Screen {
	init(
		day: Day,
		slots: [Slot],
		circuit: Circuit?
	) {
		title = day.name
		
		let alphabetical = slots.allSatisfy { $0.time == nil }
		let performers = slots.allSatisfy { $0.groupType == .corps } ? "corps" : "groups"
		subtitle = alphabetical ?
			"Performing \(performers) listed alphabetically." :
			"All times ET and subject to change."
		footer = circuit.map { "Event held as part of the \(day.year) \($0) season." }

		let slots = alphabetical ? slots.sorted(using: KeyPathComparator(\.name)) : slots
		slotScreens = slots.map(Slot.Screen.init)
	}
}
