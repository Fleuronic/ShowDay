import AppKit
import ErgoAppKit

import struct DrumCorps.Event

private import Elements

extension Event {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			item = .init(title: screen.title)
		}
	}
}
