// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import ErgoAppKit

import struct DrumCorps.Circuit

extension Circuit.Selector {
	@MainActor
	final class View: NSObject, NSMenuDelegate {
		private let toggleCircuit: (Circuit) -> Void
		private let enableAllCircuits: () -> Void

		private var item: NSMenuItem
		private var circuits: [Circuit]?
		private var excludedCircuits: Set<Circuit>?
		private var circuitItems: [NSMenuItem]?
		private var footerItems: [NSMenuItem]?
		private var allCircuitsText: String?

		@objc private func circuitItemToggled(item: NSMenuItem) {
			let circuit = item.representedObject as! Circuit
			toggleCircuit(circuit)
		}

		@objc private func allCircuitsItemEnabled() {
			enableAllCircuits()
		}

		// MARK: MenuItemDisplaying
		init(screen: Screen) {
			toggleCircuit = screen.toggleCircuit
			enableAllCircuits = screen.enableAllCircuits

			item = .init(
				title: screen.title,
				detail: screen.circuitSelectionText
			)

			allCircuitsText = screen.allCircuitsText
		}
	}
}

// MARK: -
extension Circuit.Selector.View: @MainActor MenuItemDisplaying {
	public func menuItems(with screen: Screen) -> [NSMenuItem] {
		let circuitItems = circuitItems(for: screen)
		let footerItems = footerItems(for: screen)
		let items = circuitItems + footerItems
		item.updateTitle(screen.title)
		item.updateDetail(screen.circuitSelectionText)
		item.updateSubmenuItems(items)
		return [item]
	}
}

// MARK: -
private extension Circuit.Selector.View {
	func circuitItems(for screen: Screen) -> [NSMenuItem] {
		if circuits != screen.circuits || excludedCircuits != screen.excludedCircuits {
			circuits = screen.circuits
			excludedCircuits = screen.excludedCircuits
			circuitItems = screen.circuits.map { circuit in
				.init(
					title: screen.title(for: circuit),
					enabled: screen.isCircuitEnabled(circuit),
					action: #selector(circuitItemToggled),
					target: self,
					state: screen.isCircuitExcluded(circuit) ? .off : .on,
					representedObject: circuit,
				)
			}
		}

		return circuitItems ?? []
	}

	func footerItems(for screen: Screen) -> [NSMenuItem] {
		if allCircuitsText != screen.allCircuitsText {
			allCircuitsText = screen.allCircuitsText
			footerItems = screen.allCircuitsText.map { text in
				[
					.separator(),
					.init(
						title: text,
						action: #selector(allCircuitsItemEnabled),
						target: self,
						representedObject: nil
					)
				]
			}
		}

		return footerItems ?? []
	}
}

// MARK: -
extension Circuit.Selector.Screen: @MainActor MenuBackingScreen {
	public typealias View = Circuit.Selector.View
}
