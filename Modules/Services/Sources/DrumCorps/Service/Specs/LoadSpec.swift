// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumCorps.Day
public import struct DrumCorps.Year
public import protocol Catena.Output

public protocol LoadSpec: Sendable {
	associatedtype DayLoad: Output<[Day]>

	func loadDays(in year: Year) async -> DayLoad
}

// MARK: -
public extension LoadSpec {
	typealias DayLoadResult = Result<[Day], DayLoad.Failure>
}
