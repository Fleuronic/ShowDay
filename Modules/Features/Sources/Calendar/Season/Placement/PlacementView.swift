import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

extension Placement {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var item: NSMenuItem
		private var screen: Screen

		init(screen: Screen) {
			item = .init(screen: screen)
			self.screen = screen
		}
	}
}

// MARK: -
extension Placement.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen
			item = .init(screen: screen)
		}

		return [item]
	}
}

@MainActor
private extension NSMenuItem {
	convenience init(screen: Placement.Screen) {
		self.init(
			title: screen.name,
			detail: screen.scoreText,
			icon: .init(
				systemSymbolName: screen.rankIconName,
				accessibilityDescription: nil
			),
			iconColor: .init(rankIconColor: screen.rankIconColor),
			submenuItems: [.init()]
		)
	}
}

// MARK: -
extension Placement.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.View
}

// MARK: -
private extension NSColor {
	convenience init?(rankIconColor: Placement.Screen.RankIconColor?) {
		switch rankIconColor {
		case .gold: self.init(red: Double(211) / 255, green: Double(175) / 255, blue: Double(55) / 255, alpha: 1)
		case .silver: self.init(white: 0.5, alpha: 1)
		case .bronze: self.init(red: Double(178) / 255, green: Double(124) / 255, blue: Double(93) / 255, alpha: 1)
		default: return nil
		}
	}
}
