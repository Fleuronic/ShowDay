// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Ensemble
public import struct DrumKit.Location
public import struct DrumKit.State
public import struct DrumKit.Country
public import protocol DrumKitService.EnsembleFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct EnsembleLoadFields: EnsembleFields, Hashable {
	let id: Ensemble.ID

	public let name: String
	public let location: LocationLoadFields?
}

// MARK: -
extension EnsembleLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
	
		return self.init(
			id: id,
			name: container.name,
			location: container.location()
		)
	}
}
