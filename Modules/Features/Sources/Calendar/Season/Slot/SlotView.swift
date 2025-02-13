import AppKit
import ErgoAppKit
import struct DrumCorps.Slot

extension Slot {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		init(screen: Screen) {}

		@objc private func itemSelected() {
		
		}
	}
}

// MARK: -
extension Slot.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let item = NSMenuItem(
			title: screen.title,
			detail: screen.detail,
			subtitle: screen.subtitle,
			width: 400,
			laysOutSubmenu: false
		)

		item.action = #selector(itemSelected)
		item.target = self

		return [item]
	}
}

// MARK: -
extension Slot.Screen: @MainActor MenuBackingScreen {
	public typealias View = Slot.View
}
