// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit
import struct DrumCorps.Circuit


private import Elements
extension Circuit.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let item: MenuItem

		private var screen: Screen

		@objc private func circuitItemToggled(item: NSMenuItem) {
			let circuit = item.representedObject as! Circuit
			screen.toggleCircuit(circuit)
		}

		@objc private func allCircuitsItemEnabled() {
			screen.enableAllCircuits()
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			item = .init(
				title: screen.title,
				detail: screen.circuitSelectionText
			)

			self.screen = screen

			super.init()

			item.update(submenuItems: submenuItems)
		}
	}
}

// MARK: -
extension Circuit.Selector.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		if self.screen != screen {
			self.screen = screen

			item.update(
				title: screen.title,
				detail: screen.circuitSelectionText,
			)

			item.update(submenuItems: submenuItems)
		}

		return [item]
	}
}

// MARK: -
private extension Circuit.Selector.View {
	var submenuItems: [NSMenuItem] {
		circuitItems + footerItems
	}

	var circuitItems: [MenuItem] {
		screen.circuits.map { circuit in
			MenuItem(
				title: screen.title(for: circuit),
				enabled: screen.isCircuitEnabled(circuit),
				action: #selector(circuitItemToggled),
				target: self,
				state: screen.isCircuitExcluded(circuit) ? .off : .on,
				representedObject: circuit,
			)
		}
	}

	var footerItems: [NSMenuItem] {
		screen.allCircuitsText.map { text in
			[
				.separator(),
				MenuItem(
					title: text,
					action: #selector(allCircuitsItemEnabled),
					target: self,
					representedObject: nil
				)
			]
		} ?? []
	}
}

// MARK: -
extension Circuit.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Circuit.Selector.View
}
