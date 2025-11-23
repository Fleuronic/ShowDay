// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Circuit
public import protocol DrumKitService.CircuitFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct CircuitNameAbbreviationFields: CircuitFields, Hashable {
	let id: Circuit.ID

	// TODO
	public let name: String
	public let abbreviation: String?
}

// MARK: -
extension CircuitNameAbbreviationFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			name: container.name,
			abbreviation: container.abbreviation
		)
	}
}
