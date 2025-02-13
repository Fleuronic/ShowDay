// Copyright © Fleuronic LLC. All rights reserved.// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Event

extension Event {
	enum Info {}
}

// MARK: -
extension Event.Info {
	struct Screen {
		let title: String
		let details: [String]
		let viewDetails: () -> Void
		let viewLocation: () -> Void
	}
}

// MARK: -
extension Event.Info.Screen {
	init(
		event: Event,
		viewItem: ((Any) -> Void)?
	) {
		title = event.showName!
		details = event.details
		viewDetails = { viewItem?(event) }
		viewLocation = { viewItem?(event.venue ?? event.location) }
	}
}
