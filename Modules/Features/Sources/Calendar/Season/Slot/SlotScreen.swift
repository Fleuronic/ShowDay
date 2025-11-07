// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Slot

extension Slot {
	struct Screen {
		let title: String
		let detail: String?
		let subtitle: String?
		let groupIconName: String?
		let isGroupActive: Bool?
	}
}

// MARK: -
extension Slot.Screen {
	init(slot: Slot) {
		title = slot.name
		detail = slot.detail
		subtitle = slot.timeString

		if let active = slot.isGroupActive {
			if slot.groupType == .ensemble {
				groupIconName = "horn.blast"
				isGroupActive = nil
			} else {
				groupIconName = "horn\(active ? ".blast" : "").fill"
				isGroupActive = active
			}
		} else {
			groupIconName = nil
			isGroupActive = nil
		}
	}
}
