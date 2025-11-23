// Copyright © Fleuronic LLC. All rights reserved.

public import Schemata
public import struct DrumKit.Event
public import struct DrumKit.Circuit
public import protocol DrumKitService.EventFields
public import protocol Catenary.Fields
public import protocol Catenoid.Fields

public struct EventCircuitLoadFields: EventFields {
	public let id: Event.ID
	public let circuit: CircuitNameAbbreviationFields?
}

// MARK: -
extension EventCircuitLoadFields: Catenary.Fields {
	// MARK: Fields
	public static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			circuit: container.circuit()
		)
	}
}

// MARK: -
extension EventCircuitLoadFields: Catenoid.Fields {
	// MARK: ModelProjection
	public static let projection = Projection<DrumKit.Event.Identified, Self>(
		Self.init,
		\.id,
		\.circuit.id,
		\.circuit.value.name,
		\.circuit.value.abbreviation
	)
}

// MARK: -
private extension EventCircuitLoadFields {
	init(
		id: Event.ID,
		circuitID: Circuit.ID,
		circuitName: String,
		circuitAbbreviation: String?
	) {
		self.init(
			id: id,
			circuit: .init(
				id: circuitID,
				name: circuitName,
				abbreviation: circuitAbbreviation,
			)
		)
	}
}
