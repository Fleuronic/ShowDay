

import struct DrumCorps.Placement

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
	init(placements: [Placement]) {
		placementScreens = placements.map(Placement.Screen.init)
	}
}
