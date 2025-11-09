// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

private import MemberwiseInit

extension Calendar.Season.Navigation {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let year: Int
	}
}

// MARK: -
extension Calendar.Season.Navigation.Workflow: Workflow {
	struct State {
	
	}

	enum Output {

	}

	func makeInitialState() -> State {
		.init()
	}

	func render(
		state: State,
		context: RenderContext<Self>
	) -> Calendar.Season.Navigation.Screen {
		// let sink = context.makeSink(of: Action.self)
		return .init(year: year)
	}
}

// MARK: -
private extension Calendar.Season.Navigation.Workflow {
	enum Action {
	}
}

// MARK: -
extension Calendar.Season.Navigation.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Calendar.Season.Navigation.Workflow

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		return nil
	}
}
