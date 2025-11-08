// Copyright © Fleuronic LLC. All rights reserved.

extension Season {
	enum Navigation {}
}

// MARK: -
extension Season.Navigation {
	struct Screen {
		let text: String
	}
}

// MARK: -
extension Season.Navigation.Screen {
	init(year: Int) {
		text = "\(year) Drum Corps Season"
	}
}
