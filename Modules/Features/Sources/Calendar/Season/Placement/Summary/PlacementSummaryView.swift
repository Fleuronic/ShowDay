import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

extension Placement.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var views: [Placement.View]
		private var screen: Screen

		init(screen: Screen) {
			views = .init(screen: screen)
			self.screen = screen
		}
	}
}

// MARK: -
extension Placement.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			let diff = views.count - screen.placementScreens.count
			if diff > 0 {
				views.removeLast(diff)
			} else if diff < 0 {
				views += screen.placementScreens.suffix(-diff).map(Placement.View.init)
			}
		}

		return zip(screen.placementScreens, views).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Placement.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.Summary.View
}

// MARK: -
@MainActor
private extension [Placement.View] {
	init(screen: Placement.Summary.Screen) {
		self = screen.placementScreens.map(Placement.View.init)
	}
}
