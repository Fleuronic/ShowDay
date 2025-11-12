// Copyright © Fleuronic LLC. All rights reserved.

extension Calendar.Season.Selector {
	struct Screen {
		let title = "Other Seasons"
		let year: Int
		let sections: [Section]
		let currentSeasonText: String?
		let selectSeason: (Int) -> Void
		let selectCurrentSeason: () -> Void
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen {
	struct Section {
		let rows: [Row]
	}
	
	init(
		year: Int,
		currentYear: Int,
		selectSeason: @escaping (Int) -> Void
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
	static func section(for decades: [(Int, [Int])]) -> Section {
		.init(
			rows: decades.reversed().map { decade, years in
				.init(
					title: "\(decade)s",
					content: .rows(rows(for: years))
				)
			}
		)
	}

	static func rows(for years: [Int]) -> [Section.Row] {
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
		case year(Int)
		case rows([Calendar.Season.Selector.Screen.Section.Row])
	}
}
