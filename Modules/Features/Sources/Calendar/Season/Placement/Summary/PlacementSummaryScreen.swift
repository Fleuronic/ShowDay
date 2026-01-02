// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Event
import struct DrumCorps.Day

extension Placement {
	enum Summary {}
}

// MARK: -
extension Placement.Summary {
	struct Screen {
		let placementScreens: [Placement.Screen]
	}
}

// MARK: -
extension Placement.Summary.Screen {
	init(
		placements: [Placement],
		event: Event,
		days: [Day],
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		placementScreens = placements.map { placement in
			.init(
				placement: placement,
				event: event,
				days: days,
				viewItem: viewItem,
				showContent: showContent
			)
		}
	}
}
