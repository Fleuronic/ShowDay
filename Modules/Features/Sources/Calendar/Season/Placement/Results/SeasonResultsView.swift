import AppKit
import ErgoAppKit
import struct DrumCorps.Placement

private import Elements

extension Placement.SeasonResults {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let titleItem: MenuItem

		private var placementViews: [[Placement.View]]
		private var divisionItems: [[MenuItem]]
		private var screen: Screen

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				badgedDetail: screen.detail,
				font: .systemFont(ofSize: 14, weight: .medium)
			)

			placementViews = screen.placementScreens.map { $0.1.map(Placement.View.init) }
			divisionItems = .init(placementScreens: screen.placementScreens)
			self.screen = screen
		}
	}
}

// MARK: -
extension Placement.SeasonResults.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			titleItem.update(title: screen.title, detail: screen.detail)

			let divisionDiff = divisionItems.count - screen.placementScreens.count
			if divisionDiff > 0 {
				placementViews.removeLast(divisionDiff)
				divisionItems.removeLast(divisionDiff)
			} else if divisionDiff < 0 {
				placementViews += screen.placementScreens.suffix(-divisionDiff).map { $0.1.map(Placement.View.init) }
				divisionItems += .init(placementScreens: screen.placementScreens.suffix(-divisionDiff))
			}

			for (index, screens) in screen.placementScreens.enumerated() {
				if let (divisionName, divisionDetail) = screens.0, let item = divisionItems[index].first {
					item.update(
						title: divisionName,
						detail: divisionDetail
					)
				}

				let placementDiff = placementViews[index].count - screens.1.count
				if placementDiff > 0 {
					placementViews[index].removeLast(placementDiff)
				} else if placementDiff < 0 {
					placementViews[index] += screens.1.suffix(-placementDiff).map(Placement.View.init)
				}
			}
		}

		return [titleItem] + screen.placementScreens.enumerated().flatMap { index, divisionScreens in
			let divisionItems = divisionItems[index]
			let placementViews = placementViews[index]
			let (_, screens) = divisionScreens

			return divisionItems + zip(screens, placementViews).flatMap { screen, view in
				view.menuItems(with: screen)
			}
		}
	}
}

// MARK: -
extension Placement.SeasonResults.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.SeasonResults.View
}
