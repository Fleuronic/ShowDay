

import struct DrumCorps.Slot

extension Slot {
	struct Screen {
		let title: String
		let detail: String?
		let subtitle: String?
		// let iconName: String
	}
}

// MARK: -
extension Slot.Screen {
	init(slot: Slot) {
		title = slot.name
		detail = slot.detail
		subtitle = slot.timeString
	}
}
