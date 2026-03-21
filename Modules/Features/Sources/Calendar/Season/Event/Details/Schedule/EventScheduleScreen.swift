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
		let detail: String?
		let subtitle: String
		let countText: String?
		let footer: String?
		let slotScreens: [Slot.Screen]
	}
}

// MARK: -
extension Event.Schedule.Screen {
	init(
		day: Day,
		slots: [Slot],
		circuit: Circuit?,
		viewItem: @escaping (Any) -> Void
	) {
		title = day.name
		detail = day.isUpcoming ? "\(day.countingFromToday) days from now" : "\(-day.countingFromToday) days ago"

		let alphabetical = slots.allSatisfy { $0.time == nil }
		let performers = slots.contains { $0.groupType == .ensemble } ? "groups" : "corps"
		let count = slots.count { $0.isGroupActive != nil }

		subtitle = if alphabetical {
			day.isUpcoming ? "Schedule to be determined" : "No schedule available"
		} else {
			"All times ET" + (day.isUpcoming ? " and subject to change" : "")
		}

		let tense = day.isUpcoming ? "to be " : ""
		countText = count > 0 ? "\(count) \(performers) performing" : nil
		footer = circuit.map { "Event \(tense)held as part of the \(day.year) \($0) season" }

		let slots = alphabetical ? slots.sorted(using: KeyPathComparator(\.name)) : slots
		slotScreens = slots.map { ($0, false, viewItem) }.map(Slot.Screen.init)
	}
}
