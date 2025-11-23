// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumCorps.Day
public import struct DrumCorps.Year
public import struct DrumCorps.Circuit
public import protocol Catena.Output

public protocol LoadSpec: Sendable {
	associatedtype DayLoad: Output<[Day]>
	associatedtype CircuitLoad: Output<[Circuit]>

	func loadDays(in year: Year, excluding circuits: Set<Circuit>) async -> DayLoad
	func loadCircuits(in year: Year) async -> CircuitLoad
}

// MARK: -
public extension LoadSpec {
	typealias DayLoadResult = Result<[Day], DayLoad.Failure>
	typealias CircuitLoadResult = Result<[Circuit], CircuitLoad.Failure>
}
