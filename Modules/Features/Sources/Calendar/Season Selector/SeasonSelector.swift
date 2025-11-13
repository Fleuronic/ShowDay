// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Year
import struct DrumCorps.Decade

extension Calendar.Season {
	struct Selector {
		let years: [Year]
		let nextDecades: [Decade]
		let previousDecades: [Decade]
	}
}

extension Calendar.Season.Selector {
	init(
		year: Year,
		currentYear: Year
	) {
		let startYear: Year = 1921
		let decades = Year.decades(from: startYear, to: currentYear)
		let index = decades.firstIndex { $0.years.contains(year) }!

		years = decades[index].years
		nextDecades = .init(decades[(index + 1)...])
		previousDecades = .init(decades[..<index])
	}
}
