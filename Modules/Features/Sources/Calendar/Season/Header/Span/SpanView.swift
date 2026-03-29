// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

private import Elements

extension Span {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var item: MenuItem
		private var screen: Screen

		init(screen: Screen) {
			item = .init(
				title: screen.rangeText,
				detail: screen.dayCountText,
				enabled: false,
				badged: true
			)

			self.screen = screen
		}
	}
}

// MARK: -
extension Span.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.rangeText,
				detail: screen.dayCountText
			)
		}

		return [item]
	}
}

// MARK: -
extension Span.Screen: @MainActor MenuBackingScreen {
	public typealias View = Span.View
}
