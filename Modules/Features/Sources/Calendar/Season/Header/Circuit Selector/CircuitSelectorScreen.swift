// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Circuit

extension Circuit {
	enum Selector {}
}

// MARK: -
extension Circuit.Selector {
	struct Screen {
		let title = "Included Circuits"
		let allCircuitsText: String?
		let circuitSelectionText: String
		let circuits: [Circuit]
		let toggleCircuit: (Circuit) -> Void
		let enableAllCircuits: () -> Void

		private let excludedCircuits: Set<Circuit>
	}
}

// MARK: -
extension Circuit.Selector.Screen {
	init(
		circuits: [Circuit],
		excludedCircuits: Set<Circuit>,
		toggleCircuit: @escaping (Circuit) -> Void,
		enableAllCircuits: @escaping () -> Void
	) {
		self.circuits = circuits
		self.excludedCircuits = excludedCircuits
		self.toggleCircuit = toggleCircuit
		self.enableAllCircuits = enableAllCircuits

		if excludedCircuits.isEmpty {
			allCircuitsText = nil
			circuitSelectionText = "All Circuits"
		} else {
			let selectedCircuits = Set(circuits).subtracting(excludedCircuits)
			allCircuitsText = "All Circuits"
			circuitSelectionText = selectedCircuits
				.sorted()
				.map(\.shortestName)
				.joined(separator: ", ")
		}
	}

	func title(for circuit: Circuit) -> String { 
		circuit.description 
	}

	func isCircuitExcluded(_ circuit: Circuit) -> Bool {
		excludedCircuits.contains(circuit)
	}

	func isCircuitEnabled(_ circuit: Circuit) -> Bool {
		excludedCircuits.union([circuit]).count < circuits.count
	}
}

