// Copyright © Fleuronic LLC. All rights reserved.

public import Foundation
public import Workflow
public import struct DrumCorps.Event
public import struct DrumCorps.Placement
public import struct DrumCorps.Circuit
public import struct DrumCorps.Location
public import struct DrumCorps.Venue
public import struct DrumCorps.Slot
public import struct DrumCorpsService.DayLoadWorker

private import MemberwiseInit

public extension Calendar.Season {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let year: Int
		private let loadService: LoadService
	}
}

// MARK: -
extension Calendar.Season.Workflow: Workflow {
	@dynamicMemberLookup
	public struct State {
		var season: Calendar.Season
	}

	public enum Output {
		case details(Event)
		case scores(Event)
		case circuit(Circuit)
		case venue(Venue)
		case location(Location)
		case groupURL(URL)
	}

	public func makeInitialState() -> State {
		.init(
			season: .init(
				days: .success([]),
				isLoadingDays: true
			)
		)
	}

	public func render(
		state: State,
		context: RenderContext<Self>
	) -> Calendar.Season.Screen {
		dayLoadWorker(for: state)?.running(in: context)

		let sink = context.makeSink(of: Action.self)
		return .init(
			year: year,
			days: state.days,
			isLoadingDays: state.season.isLoadingDays,
			loadDays: { sink.send(.loadDays) },
			viewItem: { sink.send(.viewItem($0)) },
		)
	}
}

// MARK: -
private extension Calendar.Season.Workflow {
	typealias Worker = AnyWorkflow<Void, WorkerAction>

	enum Action {
		case loadDays
		case viewItem(Any)
	}

	enum WorkerAction {
		case days(DayLoadWorker<LoadService>.Output)
	}

	func dayLoadWorker(for state: State) -> Worker? {
		let worker = state.isLoadingDays ? DayLoadWorker(year: year, service: loadService) : nil
		return worker?.mapOutput(WorkerAction.days)
	}
}

// MARK: -
extension Calendar.Season.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Calendar.Season.Workflow

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case .loadDays:
			state.isLoadingDays = true
		case let .viewItem(item):
			if let event = item as? Event {
				return .details(event)
			} else if let (event, _) = item as? (Event, [Placement]) {
				return .scores(event)
			} else if let circuit = item as? Circuit {
				return .circuit(circuit)
			} else if let venue = item as? Venue {
				return .venue(venue)
			} else if let location = item as? Location {
				return .location(location)
			} else if let url = item as? URL {
				return .groupURL(url)
			}
		}

		return nil
	}
}

// MARK: -
private extension Calendar.Season.Workflow.State {
	subscript<T>(dynamicMember keyPath: WritableKeyPath<Calendar.Season, T>) -> T {
		get { season[keyPath: keyPath] }
		set { season[keyPath: keyPath] = newValue }
	}
}

// MARK: -
extension Calendar.Season.Workflow.WorkerAction: WorkflowAction {
	typealias WorkflowType = Calendar.Season.Workflow

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .days(days):
			state.days = days
			state.isLoadingDays = false
		}

		return nil
	}
}

