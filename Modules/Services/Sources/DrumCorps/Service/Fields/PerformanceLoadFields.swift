// Copyright © Fleuronic LLC. All rights reserved.

public import struct DrumKit.Performance
public import protocol DrumKitService.PerformanceFields
public import protocol Catenary.Fields

private import DrumKitAPI
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct PerformanceLoadFields: PerformanceFields, Hashable {
	let id: Performance.ID

	// TODO
	public let corps: CorpsLoadFields?
	public let ensemble: EnsembleLoadFields?
	public let placement: PlacementLoadFields?
}

extension PerformanceLoadFields: Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
	
		return self.init(
			id: id,
			corps: container.corps(),
			ensemble: container.ensemble(),
			placement: container.placement()
		)
	}
}
