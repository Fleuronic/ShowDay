// Copyright © Fleuronic LLC. All rights reserved.

public import ReactiveSwift
public import WorkflowReactiveSwift
public import struct DrumCorps.Year

private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct DayLoadWorker<Service: LoadSpec>: Sendable {
	private let year: Year
	private let service: Service
}

// MARK: -
extension DayLoadWorker: Worker {
	public func run() -> SignalProducer<Service.DayLoadResult, Never> {
		.init { output in
			let results = await service.loadDays(in: year).results
			for await result in results {
				switch result {
				case let .success(days):
					output(.success(days))
				case let .failure(error):
					output(.failure(error))
				}
			}
		}
	}
}

extension DayLoadWorker: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		true
	}
}
