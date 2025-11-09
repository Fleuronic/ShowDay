// Copyright © Fleuronic LLC. All rights reserved.

public import Workflow
public import WorkflowMenuUI
public import WorkflowContainers
public import enum Calendar.Calendar

private import MemberwiseInit

public extension Root {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let loadService: LoadService
	}
}

// MARK: -
extension Root.Workflow: Workflow {
	public typealias CalendarOutput = Calendar<LoadService>.Workflow.Output

	public struct State {
		let year: Int
	}
	
	public enum Output {
		case calendar(CalendarOutput)
	}

	public func makeInitialState() -> State {
		.init(year: 2023)
	}

	public func render(
		state: State,
		context: RenderContext<Self>
	) -> Menu.Screen<AnyScreen> {
		.init(
			sections: [
				calendarWorkflow(for: state.year)
					.mapRendering(section: .calendar)
					.mapOutput(Action.handleCalendarOutput)
					.rendered(in: context)
			]
		)
	}
}

// MARK: -
private extension Root.Workflow {
	enum Action {
		case handleCalendarOutput(CalendarOutput)
	}

	func calendarWorkflow(for year: Int) -> Calendar<LoadService>.Workflow {
		.init(
			year: year,
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
		case let .handleCalendarOutput(output):
			.calendar(output)
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
