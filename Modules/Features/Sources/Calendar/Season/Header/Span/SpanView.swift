// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

extension Span {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private var item: NSMenuItem

		init(screen: Screen) {
			item = .init(
				title: screen.rangeText,
				detail: screen.dayCountText,
				enabled: false
			)
		}
	}
}

// MARK: -
extension Span.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		item.updateTitle(screen.rangeText)
		item.updateDetail(screen.dayCountText)
		return [item]
	}
}

// MARK: -
extension Span.Screen: @MainActor MenuBackingScreen {
	public typealias View = Span.View
}
