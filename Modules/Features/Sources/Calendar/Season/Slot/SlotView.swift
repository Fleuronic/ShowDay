import AppKit
import ErgoAppKit
import struct DrumCorps.Slot

extension Slot {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: NSMenuItem
		private let viewGroup: () -> Void

		init(screen: Screen) {
			item = .init(
				title: screen.title,
				detail: screen.detail,
				subtitle: screen.subtitle,
				icon: screen.groupIconName.flatMap { name in
					.init(
						systemSymbolName: name,
						accessibilityDescription: nil
					)
				},
				iconColor: .group(isActive: screen.isGroupActive),
				iconSpacing: 22,
				iconAdjustment: -1,
				width: 452,
				laysOutSubmenu: false
			)

			viewGroup = screen.viewGroup

			super.init()

			item.action = #selector(itemSelected)
			item.target = self
		}

		@objc private func itemSelected() {
			viewGroup()
		}
	}
}

// MARK: -
extension Slot.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[item]
	}
}

// MARK: -
extension Slot.Screen: @MainActor MenuBackingScreen {
	public typealias View = Slot.View
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
