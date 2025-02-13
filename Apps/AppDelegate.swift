// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import Workflow
import WorkflowMenuUI

private import SafeSFSymbols

protocol AppDelegate: NSApplicationDelegate {
	associatedtype Workflow: AnyWorkflowConvertible where Workflow.Rendering: Screen

	var workflow: Workflow { get }
}

// MARK: -
extension AppDelegate {
	func makeMenuBarItem() -> (
		NSStatusItem,
		WorkflowHostingController<Workflow.Rendering, Workflow.Output>
	) {
		let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		statusItem.button?.image = .init(.horn.blastFill)

		let controller = WorkflowHostingController(workflow: workflow)
		statusItem.menu = controller.menu

		return (statusItem, controller)
	}
}
