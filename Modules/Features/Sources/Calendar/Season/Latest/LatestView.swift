import AppKit
import ErgoAppKit

import struct DrumCorps.Day

extension Latest {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let daySummaryViews: [Day.Summary.View]
		
		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			daySummaryViews = screen.daySummaryScreens.map(Day.Summary.View.init)
		}
	}
}

// MARK: -
extension Latest.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		zip(screen.daySummaryScreens, daySummaryViews).flatMap { screen, view in 
			view.menuItems(with: screen) 
		}
	}
}

// MARK: -
extension Latest.Screen: @MainActor MenuBackingScreen {
	public typealias View = Latest.View
}
