// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Slot

extension Slot {
	struct Screen {
		let title: String
		let detail: String?
		let subtitle: String?
		let groupIconName: String?
		let isGroupActive: Bool?
		let isSelectable: Bool
		let inline: Bool
		let viewGroup: () -> Void
	}
}

// MARK: -
extension Slot.Screen {
	init(
		slot: Slot,
		inline: Bool,
		viewItem: @escaping (Any) -> Void
	) {
		title = slot.name
		detail = slot.detail
		subtitle = slot.timeString
		self.inline = inline

		viewGroup = { slot.url.map(viewItem) }
		isSelectable = slot.groupType != nil

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

// MARK: -
extension Slot.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.title == rhs.title && lhs.detail == rhs.detail && lhs.subtitle == rhs.subtitle
	}
}
