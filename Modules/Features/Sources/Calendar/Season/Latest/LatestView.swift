import AppKit
import ErgoAppKit

import struct DrumCorps.Day

extension Latest {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var daySummaryViews: [Day.Summary.View]
		private var screen: Screen

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			daySummaryViews = .init(screen: screen)
			self.screen = screen
		}
	}
}

// MARK: -
extension Latest.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			let diff = daySummaryViews.count - screen.daySummaryScreens.count
			if diff > 0 {
				daySummaryViews.removeLast(diff)
			} else if diff < 0 {
				daySummaryViews += screen.daySummaryScreens.suffix(-diff).map(Day.Summary.View.init)
			}
		}

		return zip(screen.daySummaryScreens, daySummaryViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Latest.Screen: @MainActor MenuBackingScreen {
	public typealias View = Latest.View
}

// MARK: -
@MainActor
private extension [Day.Summary.View] {
	init(screen: Latest.Screen) {
		self = screen.daySummaryScreens.map(Day.Summary.View.init)
	}
}
