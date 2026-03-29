import AppKit
import ErgoAppKit
import struct DrumCorps.Slot

private import Elements

extension Slot {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem

		private var screen: Screen

		init(screen: Screen) {
			item = .init(
				title: screen.title,
				detail: screen.detail,
				subtitle: screen.subtitle,
				icon: screen.icon,
				iconColor: .group(isActive: screen.isGroupActive),
				iconSpacing: 22,
				iconAdjustment: -1,
				width: screen.inline ? 340 : 441,
				preventsHighlighting: !screen.isSelectable
			)

			self.screen = screen

			super.init()

			item.action = #selector(itemSelected)
			item.target = self
		}

		@objc private func itemSelected() {
			screen.viewGroup()
		}
	}
}

// MARK: -
extension Slot.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.title,
				detail: screen.detail,
				subtitle: screen.subtitle,
				preventsHighlighting: !screen.isSelectable,
				icon: screen.icon,
				iconColor: .group(isActive: screen.isGroupActive),
			)
		}

		return [item]
	}
}

// MARK: -
extension Slot.Screen: @MainActor MenuBackingScreen {
	public typealias View = Slot.View
}

// MARK: -
private extension Slot.Screen {
	var icon: NSImage? {
		groupIconName.flatMap { name in
			.init(
				systemSymbolName: name,
				accessibilityDescription: nil
			)
		}
	}
}

// MARK: -
private extension NSColor {
	static func group(isActive: Bool?) -> NSColor? {
		switch isActive {
		case true: .init(calibratedWhite: 0.2, alpha: 1)
		case false: .disabledControlTextColor
		default: nil
		}
	}
}
