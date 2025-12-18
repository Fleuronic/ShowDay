// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Circuit

extension Circuit.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let toggleCircuit: (Circuit) -> Void
		private let enableAllCircuits: () -> Void

		@objc private func circuitItemToggled(item: NSMenuItem) {
			let circuit = item.representedObject as! Circuit
			toggleCircuit(circuit)
		}

		@objc private func allCircuitsItemEnabled() {
			enableAllCircuits()
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			self.toggleCircuit = screen.toggleCircuit
			self.enableAllCircuits = screen.enableAllCircuits
		}
	}
}

// MARK: -
extension Circuit.Selector.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let circuitItems = circuitItems(for: screen)
		let footerItems = footerItems(for: screen)

		return [
			.init(
				title: screen.title, 
				detail: screen.circuitSelectionText,
				submenuItems: circuitItems + footerItems
			)
		]
	}
}

private extension Circuit.Selector.View {
	func circuitItems(for screen: Screen) -> [NSMenuItem] {
		screen.circuits.map { circuit in
			NSMenuItem(
				title: screen.title(for: circuit),
				enabled: screen.isCircuitEnabled(circuit),
				action: #selector(circuitItemToggled), 
				target: self,
				state: screen.isCircuitExcluded(circuit) ? .off : .on,
				representedObject: circuit,
			)
		}
	}

	func footerItems(for screen: Screen) -> [NSMenuItem] {
		screen.allCircuitsText.map { text in
			[
				NSMenuItem.separator(),
				NSMenuItem(
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
