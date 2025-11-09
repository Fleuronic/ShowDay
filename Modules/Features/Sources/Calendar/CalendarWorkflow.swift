// Copyright © Fleuronic LLC. All rights reserved.

public import Workflow
public import WorkflowMenuUI
public import WorkflowContainers
public import Foundation
public import struct DrumCorps.Location
public import struct DrumCorps.Venue

private import MemberwiseInit

public extension Calendar {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let loadService: LoadService
	}
}

// MARK: -
extension Calendar.Workflow: Workflow {
	public enum Output {
		case url(URL)
		case location(Location)
		case venue(Venue)
	}

	public func render(
		state: Void,
		context: RenderContext<Self>
	) -> Menu.Screen<AnyScreen> {
		.init(
			sections: [
				seasonWorkflow
					.mapRendering(section: .season)
					.mapOutput(Action.handleSeasonOutput)
					.rendered(in: context)
			]
		)
	}
}

// MARK: -
private extension Calendar.Workflow {
	typealias SeasonOutput = Calendar<LoadService>.Season.Workflow.Output

	enum Action {
		case handleSeasonOutput(SeasonOutput)
	}

	var seasonWorkflow: Calendar<LoadService>.Season.Workflow {
		.init(
			year: 2023,
			loadService: loadService
		)
	}
}

// MARK: -
extension Calendar.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = Calendar.Workflow

	// MARK: WorkflowAction
	public func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .handleSeasonOutput(output):
			switch output {
			case let .details(event):
				.url(event.detailsURL!)
			case let .scores(event):
				.url(event.scoresURL!)
			case let .circuit(circuit):
				.url(circuit.url!)
			case let .location(location):
				.location(location)
			case let .venue(venue):
				.venue(venue)
			case let .groupURL(url):
				.url(url)
			}
		}
	}
}

// MARK: -
private enum Section {
	case season
	case seasonNavigation
	case seasonSelector
}

// MARK: -
private extension AnyWorkflowConvertible where Rendering: Screen {
	func mapRendering(section: Section) -> AnyWorkflow<Menu.Screen<AnyScreen>.Section, Output> {
		asAnyWorkflow().mapRendering { screen in
			.init(
				key: section,
				screen: screen.asAnyScreen()
			)
		}
	}
}
