// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumCorps.Day
public import struct DrumCorps.Year
public import struct DrumCorps.Circuit
public import protocol DrumCorpsService.LoadSpec
public import protocol Catena.ResultProviding

extension Database: LoadSpec {
	public func loadDays(in year: Year, excluding circuits: Set<Circuit>) async -> Results<Day> {
		.success([])
	}

	public func loadCircuits(in year: Year) async -> Results<Circuit> {
		.success([])
	}
}
