// Copyright © Fleuronic LLC. All rights reserved.

extension Calendar.Season {
	enum Selector {}
}

// MARK: -
extension Calendar.Season.Selector {
	struct Screen {
		let title = "Other Seasons"
		let currentSeasonText: String
		let isCurrentYear: Bool
		let selectCurrentSeason: () -> Void
	}
}

// MARK: -
extension Calendar.Season.Selector.Screen {
	init(
		year: Int,
		currentYear: Int,
		selectCurrentSeason: @escaping () -> Void
	) {
		self.selectCurrentSeason = selectCurrentSeason

		currentSeasonText = "Return to Current Season (\(currentYear))"
		isCurrentYear = year == currentYear
	}
}
