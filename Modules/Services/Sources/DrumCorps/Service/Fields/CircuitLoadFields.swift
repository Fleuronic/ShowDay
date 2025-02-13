// Copyright © Fleuronic LLC. All rights reserved.

public import Foundation
public import struct DrumKit.Circuit
public import protocol DrumKitService.CircuitFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct CircuitLoadFields: CircuitFields, Hashable {
	let id: Circuit.ID
	
	// TODO
	public let name: String
	public let abbreviation: String?
	public let url: URL?
}

// MARK: -
extension CircuitLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			name: container.name,
			abbreviation: container.abbreviation,
			url: container.url
		)
	}
}
