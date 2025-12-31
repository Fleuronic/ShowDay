// Copyright © Fleuronic LLC. All rights reserved.

public import Foundation
public import Workflow
public import struct DrumCorps.Year
public import struct DrumCorps.Event
public import struct DrumCorps.Placement
public import struct DrumCorps.Circuit
public import struct DrumCorps.Location
public import struct DrumCorps.Venue
public import struct DrumCorps.Slot
public import struct DrumCorpsService.DayLoadWorker
public import struct DrumCorpsService.CircuitLoadWorker

private import MemberwiseInit

public extension Calendar.Season {
	@_UncheckedMemberwiseInit(.public)
	struct Workflow {
		private let year: Year
		private let loadService: LoadService
	}
}

// MARK: -
extension Calendar.Season.Workflow: Workflow {
	@dynamicMemberLookup
	public struct State {
		var season: Calendar.Season
		var isLoadingDays: Bool
		var isLoadingCircuits: Bool
		var excludedCircuits: Set<Circuit>
		var loadedScreens: Set<String>
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
			season: .init(),
			isLoadingDays: false,
			isLoadingCircuits: true,
			excludedCircuits: [],
			loadedScreens: []
		)
	}

	public func render(
		state: State,
		context: RenderContext<Self>
	) -> Calendar.Season.Screen {
		dayLoadWorker(for: state)?.running(in: context)
		circuitLoadWorker(for: state)?.running(in: context)

		let sink = context.makeSink(of: Action.self)
		return .init(
			days: state.days,
			circuits: state.circuits,
			excludedCircuits: state.excludedCircuits,
			loadedScreens: state.loadedScreens,
			loadContent: { sink.send(.loadContent) },
			viewItem: { sink.send(.viewItem($0)) },
			showContent: { sink.send(.showContent($0)) },
			toggleCircuit: { sink.send(.toggleCircuit($0)) },
			enableAllCircuits: { sink.send(.enableAllCircuits) }
		)
	}

	public func workflowDidChange(from previousWorkflow: Self, state: inout State) {
		guard year != previousWorkflow.year else { return }

		state.season = .init()
		state.isLoadingCircuits = true
	}
}

// MARK: -
private extension Calendar.Season.Workflow {
	typealias Worker = AnyWorkflow<Void, WorkerAction>

	enum Action {
		case loadContent
		case viewItem(Any)
		case showContent(String)
		case toggleCircuit(Circuit)
		case enableAllCircuits
	}

	enum WorkerAction {
		case days(DayLoadWorker<LoadService>.Output)
		case circuits(CircuitLoadWorker<LoadService>.Output)
	}

	func dayLoadWorker(for state: State) -> Worker? {
		let worker = state.isLoadingDays ? DayLoadWorker(
			year: year,
			circuits: state.excludedCircuits,
			service: loadService
		) : nil

		return worker?.mapOutput(WorkerAction.days)
	}

	func circuitLoadWorker(for state: State) -> Worker? {
		let worker = state.isLoadingCircuits ? CircuitLoadWorker(
			year: year,
			service: loadService
		) : nil

		return worker?.mapOutput(WorkerAction.circuits)
	}
}

// MARK: -
extension Calendar.Season.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Calendar.Season.Workflow

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case .loadContent:
			if state.circuits != nil {
				state.isLoadingDays = true
			}
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
		case let .showContent(show):
			state.loadedScreens.insert(show)
		case let .toggleCircuit(circuit):
			if state.excludedCircuits.contains(circuit) {
				state.excludedCircuits.remove(circuit)
			} else {
				state.excludedCircuits.insert(circuit)
			}

			state.days = nil
			state.isLoadingDays = true
		case .enableAllCircuits:
			state.days = nil
			state.excludedCircuits = []
			state.isLoadingDays = true
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
			state.isLoadingDays = false
			state.days = days
		case let .circuits(circuits):
			state.isLoadingCircuits = false
			state.circuits = circuits

			if case let .success(circuits) = circuits, Set(circuits).subtracting(state.excludedCircuits).isEmpty {
				state.excludedCircuits = []
			}

			state.isLoadingDays = true
		}

		return nil
	}
}

