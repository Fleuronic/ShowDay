// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Event
import struct DrumCorps.Day
import struct DrumCorps.Placement
import struct DrumCorps.Division

extension Event.Results {
	struct Screen {
		let title: String
		let detail: String?
		let header: String
		let circuitText: String?
		let viewScores: () -> Void
		let placementScreens: [((String, String)?, [Placement.Screen])]
	}
}

// MARK: -
extension Event.Results.Screen {
	init(
		event: Event,
		days: [Day]?,
		placement: Placement? = nil,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		let results = Event.Results(event: event)
		let emphasizedPlacement = placement
		title = results.areScored ? "Full Results" : "All corps performed in exhibition"
		detail = results.areScored ? "\(results.count) competing" : nil
		header = "\(event.displayName) Results"

		switch results.setup {
		case let .single(circuit):
			let name = circuit.abbreviation ?? circuit.name
			circuitText = "Performances evaluated per \(name) judging criteria"
		case let .multiple(circuits):
			let name = circuits.compactMap(\.abbreviation).joined(separator: "/")
			circuitText = "Evaluated per respective criteria as a joint \(name) event"
		case .unaffiliated:
			circuitText = nil
		}

		viewScores = { viewItem((event, results.placements)) }
		placementScreens = results.content.map { content in
			(
				content.0.map { ($0, "\(content.1.count) competing") },
				content.1.map { placement in
					.init(
						placement: placement,
						event: event,
						days: days,
						isFullResult: true,
						isEmphasized: placement == emphasizedPlacement,
						hasSubscreens: true,
						viewItem: viewItem,
						showContent: showContent
					)
				}
			)
		}
	}
}

