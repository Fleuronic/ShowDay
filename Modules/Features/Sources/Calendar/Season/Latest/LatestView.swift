import AppKit
import ErgoAppKit

import struct DrumCorps.Day

extension Latest {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var daySummaryViews: [Day.Summary.View]

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			daySummaryViews = .init(screen: screen)
		}
	}
}

// MARK: -
extension Latest.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if daySummaryViews.count != screen.daySummaryScreens.count {
			daySummaryViews = .init(screen: screen)
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
