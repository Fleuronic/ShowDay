// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Show
public import protocol DrumKitService.ShowFields
public import protocol Catenary.Fields

//private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct ShowLoadFields: ShowFields, Hashable {
	let id: Show.ID
	
	// TODO
	public let name: String
}

// MARK: -
extension ShowLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			name: container.name
		)
	}
}
