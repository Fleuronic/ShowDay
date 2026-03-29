// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Year

extension Calendar.Season {
	enum Navigation {}
}

// MARK: -
extension Calendar.Season.Navigation {
	struct Screen {
		let text: String

		private let year: Year
	}
}

// MARK: -
extension Calendar.Season.Navigation.Screen {
	init(year: Year) {
		self.year = year
		text = "\(year) Drum Corps Season"
	}
}

// MARK: -
extension Calendar.Season.Navigation.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.year == rhs.year
	}
}
