// Copyright © Fleuronic LLC. All rights reserved.

public import Workflow
public import WorkflowMenuUI
public import WorkflowContainers
public import Foundation
public import struct DrumCorps.Location
public import struct DrumCorps.Venue

private import MemberwiseInit
private import struct Calendar.Season

public extension Root {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let loadService: LoadService
	}
}

// MARK: -
extension Root.Workflow: Workflow {
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
					.mapRendering(section: .calendar)
					.mapOutput(Action.handleSeasonOutput)
					.rendered(in: context)
			]
		)
	}
}

// MARK: -
private extension Root.Workflow {
	typealias SeasonOutput = Season<LoadService>.Workflow.Output

	enum Action {
		case handleSeasonOutput(SeasonOutput)
	}

	var seasonWorkflow: Season<LoadService>.Workflow {
		.init(
			year: 2025,
			loadService: loadService
		)
	}
}

// MARK: -
extension Root.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = Root.Workflow

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
	case calendar
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
