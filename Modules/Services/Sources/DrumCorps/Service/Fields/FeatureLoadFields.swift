// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Feature
public import protocol DrumKitService.FeatureFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct FeatureLoadFields: FeatureFields, Hashable {
	let id: Feature.ID
	
	// TODO
	public let name: String
}

extension FeatureLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			name: container.name
		)
	}
}
