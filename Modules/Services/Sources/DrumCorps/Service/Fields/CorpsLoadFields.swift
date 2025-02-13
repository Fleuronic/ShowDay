// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Corps
public import struct DrumKit.Location
public import struct DrumKit.State
public import struct DrumKit.Country
public import protocol DrumKitService.CorpsFields
public import protocol Catenary.Fields

public import Foundation
private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct CorpsLoadFields: CorpsFields, Hashable {
	let id: Corps.ID

	// TODO
	public let name: String
	public let url: URL?
	public let isActive: Bool
	public let location: LocationLoadFields
}

// MARK: -
extension CorpsLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
	
		return self.init(
			id: id,
			name: container.name,
			url: container.url,
			isActive: container.isActive,
			location: container.location()
		)
	}
}
