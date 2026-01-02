import AppKit
import ErgoAppKit

import struct DrumCorps.Event

extension Event {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: NSMenuItem

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			item = .init(title: screen.title)
		}
	}
}
