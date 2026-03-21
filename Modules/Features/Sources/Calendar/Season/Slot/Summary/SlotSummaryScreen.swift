// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Slot
import struct DrumCorps.Event

private import Foundation

extension Slot {
	enum Summary {}
}

// MARK: -
extension Slot.Summary {
	struct Screen {
		let slotScreens: [Slot.Screen]
	}
}

// MARK: -
extension Slot.Summary.Screen {
	init(
		slots: [Slot],
		viewItem: @escaping (Any) -> Void
	) {
		slotScreens = slots.map { slot in
			.init(
				slot: slot,
				inline: true,
				viewItem: viewItem
			)
		}
	}
}
