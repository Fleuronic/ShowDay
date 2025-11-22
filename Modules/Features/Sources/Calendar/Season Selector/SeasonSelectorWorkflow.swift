// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import struct DrumCorps.Year

private import Foundation
private import MemberwiseInit

extension Calendar.Season.Selector {
	struct Workflow {
		private let year: Year
		private let currentYear: Year

		init(year: Year) {
			self.year = year
			
			let calendar = Foundation.Calendar.current
			currentYear = .init(value: calendar.component(.year, from: Date.now))
		}
	}
}

// MARK: -
extension Calendar.Season.Selector.Workflow: Workflow {
	typealias Output = Year

	func render(
		state: Void,
		context: RenderContext<Self>
	) -> Calendar.Season.Selector.Screen {
		let sink = context.makeSink(of: Action.self)
		return .init(
			year: year,
			currentYear: currentYear,
			selectSeason: { sink.send(.selectSeason(year: $0)) }
		)
	}
}

// MARK: -
private extension Calendar.Season.Selector.Workflow {
	enum Action {
		case selectSeason(year: Year)
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
