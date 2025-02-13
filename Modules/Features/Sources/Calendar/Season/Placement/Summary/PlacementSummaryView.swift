import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

extension Placement.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let views: [Placement.View]

		private let items: [NSMenuItem]

		init(screen: Screen) {
			views = screen.placementScreens.map(Placement.View.init)
			items = zip(screen.placementScreens, views).flatMap { screen, view in
				view.menuItems(with: screen)
			}
		}
	}
}

// MARK: -
extension Placement.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		items
	}
}

// MARK: -
extension Placement.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.Summary.View
}
