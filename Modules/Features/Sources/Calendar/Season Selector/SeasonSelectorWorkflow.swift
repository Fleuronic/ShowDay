// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

private import MemberwiseInit

extension Calendar.Season.Selector {
	struct Workflow {
		private let year: Int
		private let currentYear: Int

		init(year: Int) {
			self.year = year
			
			currentYear = 2025
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.Workflow: Workflow {
	typealias Output = Int

	func render(
		state: Void,
		context: RenderContext<Self>
	) -> Calendar.Season.Selector.Screen {
		let sink = context.makeSink(of: Action.self)
		return .init(
			year: year,
			currentYear: currentYear,
			selectCurrentSeason: { sink.send(.selectSeason(year: currentYear)) }
		)
	}
}

// MARK: -
private extension Calendar.Season.Selector.Workflow {
	enum Action {
		case selectSeason(year: Int)
	}
}

// MARK: -
extension Calendar.Season.Selector.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Calendar.Season.Selector.Workflow

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .selectSeason(year): year
		}
	}
}
