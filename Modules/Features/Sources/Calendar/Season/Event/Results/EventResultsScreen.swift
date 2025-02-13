// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Division

extension Event.Results {
	struct Screen {
		let title: String
		let circuitText: String?
		let placementScreens: [(String?, [Placement.Screen])]
		let viewScores: () -> Void
	}
}

// MARK: -
extension Event.Results.Screen {
	init(
		event: Event,
		viewItem: ((Any) -> Void)?
	) {
		let results = Event.Results(event: event)
		title = results.areScored ? "Full Results" : "All corps performed in exhibition."
		
		switch results.setup {
		case let .single(circuit):
			let name = circuit.abbreviation ?? circuit.name
			circuitText = "Performances evaluated per \(name) judging criteria."
		case let .multiple(circuits):
			let name = circuits.compactMap(\.abbreviation).joined(separator: "/")
			circuitText = "Evaluated per respective criteria as a joint \(name) event."
		case .unaffiliated:
			circuitText = nil
		}

		placementScreens = results.content.map { ($0.0, $0.1.map(Placement.Screen.init)) }
		viewScores = { viewItem?((event, results.placements)) }
	}

	var detail: String {
		"Final Scores"
	}
}
