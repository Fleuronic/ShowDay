// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Placement
public import protocol DrumKitService.PlacementFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct PlacementLoadFields: PlacementFields, Hashable {
	let id: Placement.ID

	// TODO
	public let rank: Int
	public let score: Double
	public let division: DivisionLoadFields?
}

// MARK: -
extension PlacementLoadFields: Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			rank: container.rank,
			score: container.score,
			division: container.division()
		)
	}
}
