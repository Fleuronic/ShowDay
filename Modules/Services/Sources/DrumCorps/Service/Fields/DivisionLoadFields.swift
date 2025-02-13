// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Division
public import struct DrumKit.Circuit
public import protocol DrumKitService.DivisionFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct DivisionLoadFields: DivisionFields, Hashable {
	public let id: Division.ID

	// TODO
	public let name: String
	public let circuit: CircuitLoadFields
}

// MARK: -
extension DivisionLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			name: container.name,
			circuit: container.circuit()
		)
	}
}
