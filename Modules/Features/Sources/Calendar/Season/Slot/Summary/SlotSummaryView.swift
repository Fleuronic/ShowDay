import AppKit
import ErgoAppKit
import struct DrumCorps.Slot

extension Slot.Summary {
	@MainActor
	final class View: NSObject {
		private var views: [Slot.View]
		private var screen: Screen

		init(screen: Screen) {
			views = .init(screen: screen)
			self.screen = screen
		}
	}
}

// MARK: -
extension Slot.Summary.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			let diff = views.count - screen.slotScreens.count
			if diff > 0 {
				views.removeLast(diff)
			} else if diff < 0 {
				views += screen.slotScreens.suffix(-diff).map(Slot.View.init)
			}
		}

		return zip(screen.slotScreens, views).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Slot.Summary.Screen: @MainActor MenuBackingScreen {
	public typealias View = Slot.Summary.View
}

// MARK: -
@MainActor
private extension [Slot.View] {
	init(screen: Slot.Summary.Screen) {
		self = screen.slotScreens.map(Slot.View.init)
	}
}
