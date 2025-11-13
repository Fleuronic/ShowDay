// Copyright © Fleuronic LLC. All rights reserved.

public import DrumCorps
public import protocol DrumCorpsService.LoadSpec
public import protocol Catena.ResultProviding

extension Database: LoadSpec {
	public func loadDays(in year: Year) async -> Results<Day> {
		.success([])
	}
}
