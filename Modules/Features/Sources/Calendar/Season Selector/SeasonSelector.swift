// Copyright © Fleuronic LLC. All rights reserved.

extension Calendar.Season {
	struct Selector {
		let years: [Int]
		let nextDecades: [(Int, [Int])]
		let previousDecades: [(Int, [Int])]
	}
}

extension Calendar.Season.Selector {
	init(
		year: Int,
		currentYear: Int
	) {
		let startYear = 1921
		let decades = stride(from: startYear, to: currentYear, by: .decadeLength).map {
			$0 / .decadeLength * .decadeLength
		}
		
		let decade = decades.first { year < $0 + .decadeLength }!
		years = Self.years(in: decade, from: startYear, to: currentYear)
		nextDecades = Self.decades(from: decades, from: startYear, to: currentYear) { $0 > decade }
		previousDecades = Self.decades(from: decades, from: startYear, to: currentYear) { $0 < decade }
	}
}

// MARK: -
private extension Calendar.Season.Selector {
	static func years(in decade: Int, from startYear: Int, to currentYear: Int) -> [Int] {
		(decade..<(decade + .decadeLength)).filter { year in
			year >= startYear && year <= currentYear && year != 2020
		}
	}

	static func decades(from decades: [Int], from startYear: Int, to currentYear: Int, comparator: (Int) -> Bool) -> [(Int, [Int])] {
		decades.filter(comparator).map { decade in
			(decade, years(in: decade, from: startYear, to: currentYear))
		}
	}
}

// MARK: -
private extension Int {
	static let decadeLength = 10
}
