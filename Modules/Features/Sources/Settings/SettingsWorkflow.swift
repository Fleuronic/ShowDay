// Copyright © Fleuronic LLC. All rights reserved.

public import Workflow

public extension Settings {
	struct Workflow {
		public init() {}
	}
}

// MARK: -
extension Settings.Workflow: Workflow {
	public enum Output {
		case quit
	}

	public func render(
		state: Void,
		context: RenderContext<Self>
	) -> Settings.Screen {
		let sink = context.makeSink(of: Action.self)
		return .init { 
			sink.send(.quit) 
		}
	}
}

// MARK: -
private extension Settings.Workflow {
	enum Action {
		case quit
	}
}

// MARK: -
extension Settings.Workflow.Action: WorkflowAction {
	public typealias WorkflowType = Settings.Workflow

	// MARK: WorkflowAction
	public func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case .quit: .quit
		}
	}
}
