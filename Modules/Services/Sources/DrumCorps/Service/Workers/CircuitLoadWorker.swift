// Copyright © Fleuronic LLC. All rights reserved.

public import ReactiveSwift
public import WorkflowReactiveSwift
public import struct DrumCorps.Year
public import struct DrumCorps.Circuit

private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct CircuitLoadWorker<Service: LoadSpec>: Sendable {
	private let year: Year
	private let service: Service
}

// MARK: -
extension CircuitLoadWorker: Worker {
	public func run() -> SignalProducer<Service.CircuitLoadResult, Never> {
		.init { output in
			let results = await service.loadCircuits(in: year).results
			for await result in results {
				switch result {
				case let .success(circuits):
					output(.success(circuits))
				case let .failure(error):
					output(.failure(error))
				}
			}
		}
	}
}

extension CircuitLoadWorker: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		true
	}
}
