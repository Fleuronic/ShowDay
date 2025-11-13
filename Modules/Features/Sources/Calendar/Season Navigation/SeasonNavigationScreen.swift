// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Year

extension Calendar.Season {
	enum Navigation {}
}

// MARK: -
extension Calendar.Season.Navigation {
	struct Screen {
		let text: String
	}
}

// MARK: -
extension Calendar.Season.Navigation.Screen {
	init(year: Year) {
		text = "\(year) Drum Corps Season"
	}
}
