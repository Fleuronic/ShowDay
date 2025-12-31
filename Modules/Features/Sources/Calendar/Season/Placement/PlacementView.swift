import AppKit
import ErgoAppKit
import struct DrumCorps.Placement
import struct DrumCorps.Event

extension Placement {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let loadingItem: NSMenuItem
		private let showContent: (String) -> Void

		private var seasonResultsView: Placement.SeasonResults.View?
		private var eventResultsView: Event.Results.View?
		private var item: NSMenuItem
		private var screen: Screen
		private var isShowingContent = false
		private var viewScores: () -> Void

		@objc private func itemSelected() {
			viewScores()
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			loadingItem = .init(
				title: "Loading…",
				width: 325,
				enabled: false
			)

			showContent = screen.showContent
			item = .init(
				screen: screen,
				loadingItem: loadingItem
			)

			viewScores = screen.viewScores
			self.screen = screen

			super.init()

			item.submenu?.delegate = self
			if screen.eventResultsScreen == nil {
				item.target = self
				item.action = #selector(itemSelected)
			}
		}

		// MARK: NSMenuDelegate
		public func menuWillOpen(_ menu: NSMenu) {
			if !isShowingContent {
				isShowingContent = true
				showContent(description)
			}
		}
	}
}

// MARK: -
extension Placement.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen.title != screen.title { // TODO: Should all be screens
			self.screen = screen

			item = .init(
				screen: screen,
				loadingItem: loadingItem
			)

			item.submenu?.delegate = self
			isShowingContent = false
			seasonResultsView = nil
			eventResultsView = nil
		}

		if isShowingContent {
			if let seasonResultsScreen = screen.seasonResultsScreen {
				let seasonResultsView = seasonResultsView ?? .init(screen: seasonResultsScreen)
				let items = seasonResultsView.menuItems(with: seasonResultsScreen)
				item.updateSubmenuItems(items)
				self.seasonResultsView = seasonResultsView
			} else if let eventResultsScreen = screen.eventResultsScreen {
				let eventResultsView = eventResultsView ?? .init(screen: eventResultsScreen)
				let items = eventResultsView.menuItems(with: eventResultsScreen)[0].submenu!.items
				item.updateSubmenuItems(items)
				self.eventResultsView = eventResultsView
			}
		}

		viewScores = screen.viewScores

		return [item]
	}
}

@MainActor
private extension NSMenuItem {
	convenience init(
		screen: Placement.Screen,
		loadingItem: NSMenuItem
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
			width: screen.subtitle == nil && !screen.isFullResult ? 325 : 425,
			emphasized: screen.isEmphasized,
			submenuItems: screen.eventResultsScreen.map { _ in [loadingItem] } ?? [],
			laysOutSubmenu: screen.eventResultsScreen != nil
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
