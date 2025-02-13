//
//  File.swift
//  Services
//
//  Created by Jordan Kay on 10/12/25.
//

public import protocol Catena.Output
public import protocol Catena.ResultProviding

import ReactiveSwift

private import Catenoid
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct Service<
	API: LoadSpec & ResultProviding,
	Database: LoadSpec & SaveSpec & ResultProviding
>: Sendable where Database.Error == Never {
	let api: API
	let database: Database
}

// MARK: -
extension SignalProducer where Error == Never {
	init(handler: @Sendable @escaping ((Value) -> Void) async -> Void) {
		self = .init { observer, lifetime in
			let task = Task {
				await handler(observer.send)
				observer.sendCompleted()
			}

			lifetime.observeEnded {
				task.cancel()
			}
		}
	}
}

// MARK: -
extension Signal.Observer: @unchecked Swift.Sendable {}
