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
	init?(
		event: Event,
		days: [Day]?,
		placement: Placement? = nil,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		guard
			case let results = Event.Results(event: event),
			results.areScored else { return nil }

		let emphasizedPlacement = placement
		title = "Full Results"
		detail = "\(results.count) competing"
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

// MARK: -
extension Event.Results.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.title == rhs.title && lhs.placementScreens.map(\.1) == rhs.placementScreens.map(\.1)
	}
}

