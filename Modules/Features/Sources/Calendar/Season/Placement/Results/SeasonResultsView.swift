import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

private import Elements

extension Placement.SeasonResults {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: MenuItem

		private var placementViews: [Placement.View]

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				badgedDetail: screen.subtitle,
				font: .systemFont(ofSize: 14, weight: .medium)
			)

			placementViews = .init(screen: screen)
		}
	}
}

// MARK: -
extension Placement.SeasonResults.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if placementViews.count != screen.placementScreens.count {
			titleItem.updateTitle(screen.title)
			placementViews = .init(screen: screen)
		}

		return [titleItem] + zip(screen.placementScreens, placementViews).flatMap { screen, view in
			view.menuItems(with: screen)
		}
	}
}

// MARK: -
extension Placement.SeasonResults.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.SeasonResults.View
}

// MARK: -
@MainActor
private extension [Placement.View] {
	init(screen: Placement.SeasonResults.Screen) {
		self = screen.placementScreens.map(Placement.View.init)
	}
}
