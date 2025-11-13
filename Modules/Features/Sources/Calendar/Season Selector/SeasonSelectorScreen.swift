// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Year
import struct DrumCorps.Decade

extension Calendar.Season.Selector {
	struct Screen {
		let title = "Other Seasons"
		let year: Year
		let sections: [Section]
		let currentSeasonText: String?
		let selectSeason: (Year) -> Void
		let selectCurrentSeason: () -> Void
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen {
	struct Section {
		let rows: [Row]
	}
	
	init(
		year: Year,
		currentYear: Year,
		selectSeason: @escaping (Year) -> Void
	) {
		let selector = Calendar.Season.Selector(
			year: year,
			currentYear: currentYear
		)
		
		sections = [
			Self.section(for: selector.nextDecades),
			.init(rows: Self.rows(for: selector.years)),
			Self.section(for: selector.previousDecades)
		]

		self.year = year
		self.selectSeason = selectSeason
		
		selectCurrentSeason = { selectSeason(currentYear) }
		currentSeasonText = year == currentYear ? nil : "Return to Current Season (\(currentYear))"
	}
}

// MARK: -
private extension Calendar.Season.Selector.Screen {
	static func section(for decades: [Decade]) -> Section {
		.init(
			rows: decades.reversed().map { decade in
				.init(
					title: decade.name,
					content: .rows(rows(for: decade.years))
				)
			}
		)
	}

	static func rows(for years: [Year]) -> [Section.Row] {
		years.reversed().map { year in
			.init(
				title: "\(year) Season", 
				content: .year(year)
			)
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen.Section {
	struct Row {
		let title: String
		let content: Content
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen.Section.Row {
	enum Content {
		case year(Year)
		case rows([Calendar.Season.Selector.Screen.Section.Row])
	}
}
