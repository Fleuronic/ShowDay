// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Location
public import struct DrumKit.State
public import struct DrumKit.Country
public import protocol DrumKitService.LocationFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct LocationLoadFields: LocationFields, Hashable {
	let id: Location.ID
	
	// TODO
	public let city: String
	public let state: String
	public let country: String
}

// MARK: -
extension LocationLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
		let stateContainer = container.stateContainer
		let countryContainer = stateContainer.countryContainer

		return self.init(
			id: id,
			city: container.city,
			state: stateContainer.abbreviation,
			country: countryContainer.name
		)
	}
}
