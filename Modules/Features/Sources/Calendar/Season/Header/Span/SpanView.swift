// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

extension Span {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		init(screen: Screen) {}
	}
}

// MARK: -
extension Span.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		[
			.init(
				title: screen.rangeText,
				detail: screen.dayCountText,
				enabled: false
			)
		]
	}
}

// MARK: -
extension Span.Screen: @MainActor MenuBackingScreen {
	public typealias View = Span.View
}
