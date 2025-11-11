// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
import Workflow
import WorkflowMenuUI
import WorkflowContainers
import enum Root.Root
import struct DrumCorpsAPI.API
import struct DrumCorpsDatabase.Database
import struct DrumCorpsService.Service

private import struct DrumCorps.Location
private import struct DrumCorps.Venue

private import MapKit

extension RootApp {
	final class Delegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
		private var database: Database!
		private var statusItem: NSStatusItem!
		private var controller: WorkflowHostingController<Menu.Screen<AnyScreen>, Void>!

		// MARK: NSApplicationDelegate
		func applicationDidFinishLaunching(_ notification: Notification) {
			Task {
				database = await .init()
				(statusItem, controller) = makeMenuBarItem()
			}
		}
	}
}

// MARK: -
extension RootApp.Delegate: @MainActor AppDelegate {
	// MARK: AppDelegate
	typealias Workflow = AnyWorkflow<Menu.Screen<AnyScreen>, Void>

	var workflow: Workflow {
		Root.Workflow(
			loadService: Service(
				api: API(),
				database: database
			)
		).mapOutput { output in
			switch output {
			case let .calendarOutput(output):
				switch output {
				case let .url(url):
					self.open(url)
				case let .location(location):
					self.show(location)
				case let .venue(venue):
					self.show(venue)
				}
			case .termination:
				self.terminate()
			}
		}
	}
}

// MARK: -
private extension RootApp.Delegate {
	func open(_ url: URL) {
		NSWorkspace.shared.open(url)
	}

	func open(_ item: MKMapItem) {
		item.openInMaps(launchOptions: nil)
	}

	func show(_ location: Location) {
		Task {
			await open(location.mapItem)
		}
	}

	func show(_ venue: Venue) {
		Task {
			await open(venue.mapItem)
		}
	}

	func terminate() {
		NSApp.terminate(nil)
	}
}
