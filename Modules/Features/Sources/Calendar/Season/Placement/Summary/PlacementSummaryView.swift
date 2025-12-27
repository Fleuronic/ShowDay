import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

extension Placement.Summary {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var views: [Placement.View]

		init(screen: Screen) {
			views = .init(screen: screen)
		}
	}
}

// MARK: -
extension Placement.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if views.count != screen.placementScreens.count {
			views = .init(screen: screen)
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
