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

		init(screen: Screen) {
			titleItem = .init(
				title: screen.title,
				badgedDetail: screen.detail,
				font: .systemFont(ofSize: 14, weight: .medium)
			)

			placementViews = .init(screen: screen)
			divisionItems = .init(screen: screen)
		}
	}
}

// MARK: -
extension Placement.SeasonResults.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if placementViews.map(\.count) != screen.placementScreens.map(\.1.count) {
			titleItem.updateTitle(screen.title)
			titleItem.updateDetail(screen.detail)
			placementViews = .init(screen: screen)
			divisionItems = .init(screen: screen)
		}

		return [titleItem] + .init(
			screen: screen,
			divisionItems: divisionItems,
			placementViews: placementViews
		)
	}
}

// MARK: -
extension Placement.SeasonResults.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.SeasonResults.View
}



// MARK: -
@MainActor
private extension [[Placement.View]] {
	init(screen: Placement.SeasonResults.Screen) {
		self = screen.placementScreens.map { $0.1.map(Placement.View.init) }
	}
}

// MARK: -
@MainActor
private extension [NSMenuItem] {
	init(
		screen: Placement.SeasonResults.Screen,
		divisionItems: [[NSMenuItem]],
		placementViews: [[Placement.View]]
	) {
		self = screen.placementScreens.enumerated().flatMap { index, divisionScreens in
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
@MainActor
private extension [[MenuItem]] {
	init(screen: Placement.SeasonResults.Screen) {
		self = zip(screen.placementScreens, screen.details).map { (divisionScreens, detail) in
			let (divisionName, _) = divisionScreens
			return divisionName.map { divisionName in
				[
					.init(
						title: divisionName,
						badgedDetail: detail,
						font: .systemFont(ofSize: 12)
					)
				]
			} ?? []
		}
	}
}
