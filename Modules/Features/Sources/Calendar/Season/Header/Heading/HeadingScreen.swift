// Copyright © Fleuronic LLC. All rights reserved.

enum Heading {}

// MARK: -
extension Heading {
	struct Screen {
		let text: String
	}
}

// MARK: -
extension Heading.Screen {
	init(year: Int) {
		text = "\(year) Drum Corps Season"
	}
}
