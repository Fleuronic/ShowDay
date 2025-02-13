// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Slot
import struct DrumKit.Time
import struct DrumCorpsService.PerformanceLoadFields
import struct DrumCorpsService.FeatureLoadFields
import protocol DrumKitService.SlotFields
import protocol Catenary.Fields

struct SlotLoadFields: SlotFields, Hashable, Sendable /*TODO*/ {
	let id: Slot.ID
	let time: Time?
	let performance: PerformanceLoadFields?
	let feature: FeatureLoadFields?
}

// MARK: -
extension SlotLoadFields: Fields {
	// MARK: Fields
	static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)
	
		return self.init(
			id: id,
			time: container.time,
			performance: container.performance(),
			feature: container.feature()
		)
	}
}
