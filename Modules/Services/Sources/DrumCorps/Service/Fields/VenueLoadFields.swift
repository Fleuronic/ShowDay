// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Venue
public import struct DrumKit.Address
public import struct DrumKit.ZIPCode
public import protocol DrumKitService.VenueFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct VenueLoadFields: VenueFields, Hashable {
	let id: Venue.ID
	
	// TODO
	public let name: String
	public let host: String?
	public let streetAddress: String
	public let zipCode: String
}

// MARK: -
extension VenueLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
		let addressContainer = container.addressContainer
		let zipCodeContainer = addressContainer.zipCodeContainer

		return self.init(
			id: id,
			name: container.name,
			host: container.host,
			streetAddress: addressContainer.streetAddress,
			zipCode: zipCodeContainer.code
		)
	}
}
