
public import enum Catenary.Error
public import enum Catenary.Request
public import struct DrumCorps.Day
public import struct DrumCorps.Year
public import struct DrumCorps.Circuit
public import protocol Catena.ResultProviding

extension Service: LoadSpec where
	API.DayLoad == Result<[Day], API.Error>,
	API.CircuitLoad == Result<[Circuit], API.Error>,
	API.Error == Error<Request.Error> {
	public func loadDays(in year: Year, excluding circuits: Set<Circuit>) async -> API.DayLoad {
		await api.loadDays(in: year, excluding: circuits)
	}

	public func loadCircuits(in year: Year) async -> API.CircuitLoad {
		await api.loadCircuits(in: year)
	}
}
