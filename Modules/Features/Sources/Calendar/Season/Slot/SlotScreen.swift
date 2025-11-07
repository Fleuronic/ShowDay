// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Slot

extension Slot {
	struct Screen {
		let title: String
		let detail: String?
		let subtitle: String?
		let groupIconName: String?
		let isGroupActive: Bool?
		let viewGroup: () -> Void
	}
}

// MARK: -
extension Slot.Screen {
	init(
		slot: Slot,
		viewItem: @escaping (Any) -> Void
	) {
		title = slot.name
		detail = slot.detail
		subtitle = slot.timeString
		viewGroup = { slot.url.map(viewItem) }

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
