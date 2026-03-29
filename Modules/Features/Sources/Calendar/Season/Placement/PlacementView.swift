import AppKit
import ErgoAppKit
import struct DrumCorps.Placement
import struct DrumCorps.Event

private import Elements

extension Placement {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem

		private var eventResultsScreen: Event.Results.Screen?
		private var seasonResultsScreen: Placement.SeasonResults.Screen?
		private var seasonResultsView: Placement.SeasonResults.View?
		private var eventResultsView: Event.Results.View?
		private var screen: Screen
		private var shouldShowContent = false

		@objc private func itemSelected() {
			screen.viewScores()
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			eventResultsScreen = screen.eventResultsScreen
			seasonResultsScreen = screen.seasonResultsScreen

			item = .init(
				screen: screen,
				hasEventResults: eventResultsScreen != nil
			)

			self.screen = screen

			super.init()

			item.submenu?.delegate = self

			if eventResultsScreen == nil {
				item.target = self
				item.action = #selector(itemSelected)
			}
		}

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			if !shouldShowContent {
				shouldShowContent = true
				screen.showContent(description)
			}
		}
	}
}

// MARK: -
extension Placement.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.title,
				detail: screen.scoreText,
				subtitle: screen.subtitle,
				prefix: screen.scoreDeltaPrefix,
				prefixColor: screen.scoreDeltaPrefixColor,
				emphasized: screen.isEmphasized,
				icon: .init(
					systemSymbolName: screen.rankIconName,
					accessibilityDescription: nil
				),
				iconColor: .init(rankIconColor: screen.rankIconColor)
			)
		}

		if shouldShowContent {
			shouldShowContent = false
			eventResultsScreen = screen.eventResultsScreen
			seasonResultsScreen = screen.seasonResultsScreen

			if let seasonResultsScreen {
				let seasonResultsView = seasonResultsView ?? .init(screen: seasonResultsScreen)
				let items = seasonResultsView.menuItems(with: seasonResultsScreen)
				self.seasonResultsView = seasonResultsView

				eventResultsView = nil
				item.update(submenuItems: items)
			} else if let eventResultsScreen {
				let eventResultsView = eventResultsView ?? .init(screen: eventResultsScreen)
				let items = eventResultsView.menuItems(with: eventResultsScreen)[0].submenu!.items
				self.eventResultsView = eventResultsView

				seasonResultsView = nil
				item.update(submenuItems: items)
			}
		}

		return [item]
	}
}

@MainActor
private extension MenuItem {
	convenience init(
		screen: Placement.Screen,
		hasEventResults: Bool
	) {
		self.init(
			title: screen.title,
			detail: screen.scoreText,
			subtitle: screen.subtitle,
			icon: .init(
				systemSymbolName: screen.rankIconName,
				accessibilityDescription: nil
			),
			iconColor: .init(rankIconColor: screen.rankIconColor),
			width: screen.subtitle == nil ? (screen.isFullResult ? 340 : 325) : 425,
			emphasized: screen.isEmphasized,
			monospacedDetail: true,
			prefix: screen.scoreDeltaPrefix,
			prefixColor: screen.scoreDeltaPrefixColor,
			submenuItems: hasEventResults ? [.init()] : [],
			padDetail: hasEventResults
		)
	}
}

// MARK: -
extension Placement.Screen: @MainActor MenuBackingScreen {
	public typealias View = Placement.View
}

// MARK: -
private extension NSColor {
	convenience init?(rankIconColor: Placement.Screen.RankIconColor?) {
		switch rankIconColor {
		case .gold: self.init(red: Double(211) / 255, green: Double(175) / 255, blue: Double(55) / 255, alpha: 1)
		case .silver: self.init(white: 0.5, alpha: 1)
		case .bronze: self.init(red: Double(178) / 255, green: Double(124) / 255, blue: Double(93) / 255, alpha: 1)
		default: return nil
		}
	}
}
