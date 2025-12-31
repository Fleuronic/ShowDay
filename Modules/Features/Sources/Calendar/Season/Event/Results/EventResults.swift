// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Event
import struct DrumCorps.Placement
import struct DrumCorps.Circuit

extension Event {
	struct Results {
		let setup: Setup
		let content: [(String?, [Placement])]
	}
}

// MARK: -
extension Event.Results {
	enum Setup {
		case single(Circuit)
		case multiple([Circuit])
		case unaffiliated
	}

	init(event: Event) {
		let placements = event.placements
		let circuits = Array(Set(placements.compactMap(\.0?.circuit))).sorted()
		content = placements.map { division, placements in
			let divisionName = division.map {
				circuits.count > 1 ? "\($0.circuit.abbreviation!) \($0.name)" : $0.name
			}

			return (divisionName, placements)
		}

		setup = if let circuit = event.circuit {
			if circuits.count > 1 {
				.multiple(circuits)
			} else {
				.single(circuit)
			}
		} else {
			.unaffiliated
		}
	}

	var placements: [Placement] {
		content.flatMap(\.1)
	}

	var areScored: Bool {
		!placements.isEmpty
	}
}
