// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumCorps.Day
public import struct DrumCorps.Year
public import protocol DrumCorpsService.LoadSpec
public import protocol Catena.ResultProviding

extension Database: LoadSpec {
	public func loadDays(in year: Year) async -> Results<Day> {
		.success([])
	}
}
