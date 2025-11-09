// Copyright © Fleuronic LLC. All rights reserved.

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
	init(year: Int) {
		text = "\(year) Drum Corps Season"
	}
}
