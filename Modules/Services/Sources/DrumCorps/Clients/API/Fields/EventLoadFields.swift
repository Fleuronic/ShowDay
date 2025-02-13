// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import Foundation
import struct DrumKit.Event
import struct DrumKit.Location
import struct DrumKit.Address
import struct DrumKit.State
import struct DrumKit.Country
import struct DrumKit.ZIPCode
import struct DrumKit.Circuit
import struct DrumKit.Show
import struct DrumKit.Venue
import struct DrumKit.Slot
import struct DrumKit.Time
import struct DrumKit.Performance
import struct DrumKit.Corps
import struct DrumKit.Ensemble
import struct DrumKit.Placement
import struct DrumKit.Division
import struct DrumKit.Feature
import struct DrumCorpsService.LocationLoadFields
import struct DrumCorpsService.ShowLoadFields
import struct DrumCorpsService.VenueLoadFields
import struct DrumCorpsService.CircuitLoadFields
import protocol DrumKitService.EventFields
import protocol Catenary.Fields
import protocol Catenoid.Fields

struct EventLoadFields: EventFields {
	let id: Event.ID
	let date: Date
	let detailsURL: URL?
	let scoresURL: URL?
	let location: LocationLoadFields
	let circuit: CircuitLoadFields?
	let show: ShowLoadFields?
	let venue: VenueLoadFields?
	let slots: [SlotLoadFields]
}

// MARK: -
extension EventLoadFields: Catenary.Fields {
	// MARK: Fields
	static func decoded(from decoder: any Decoder) throws -> Self {
		let (id, container) = try Model.deserialized(from: decoder)

		return self.init(
			id: id,
			date: container.date,
			detailsURL: container.detailsURL,
			scoresURL: container.scoresURL,
			location: container.location(),
			circuit: container.circuit(),
			show: container.show(),
			venue: container.venue(),
			slots: container.slots()
		)
	}
}

// MARK: -
extension EventLoadFields: Catenoid.Fields {
	// MARK: ModelProjection
	public static let projection = Projection<DrumKit.Event.Identified, Self>(
		Self.init,
		\.id,
		\.value.date,
		\.value.detailsURL,
		\.value.scoresURL,
		\.location.id,
		\.location.value.city,
		\.location.state.value.abbreviation,
		\.location.state.country.value.name,
		\.circuit.id,
		\.circuit.value.name,
		\.circuit.value.abbreviation,
		\.circuit.value.url,
		\.show.id,
		\.show.value.name,
		\.venue.id,
		\.venue.value.name,
		\.venue.value.host,
		\.venue.address.value.streetAddress,
		\.venue.address.zipCode.value.code,
		\.slots.id,
		\.slots.value.time,
		\.slots.performance.id,
		\.slots.performance.corps.id,
		\.slots.performance.corps.value.name,
		\.slots.performance.corps.value.url,
		\.slots.performance.corps.value.isActive,
		\.slots.performance.corps.location.id,
		\.slots.performance.corps.location.value.city,
		\.slots.performance.corps.location.state.value.abbreviation,
		\.slots.performance.corps.location.state.country.value.name,
		\.slots.performance.placement.id,
		\.slots.performance.placement.value.rank,
		\.slots.performance.placement.value.score,
		\.slots.performance.placement.division.id,
		\.slots.performance.placement.division.value.name,
		\.slots.performance.placement.division.circuit.id,
		\.slots.performance.placement.division.circuit.value.name,
		\.slots.performance.placement.division.circuit.value.abbreviation,
		\.slots.performance.placement.division.circuit.value.url,
		\.slots.performance.ensemble.id,
		\.slots.performance.ensemble.value.name,
		\.slots.performance.ensemble.location.id,
		\.slots.performance.ensemble.location.value.city,
		\.slots.performance.ensemble.location.state.value.abbreviation,
		\.slots.performance.ensemble.location.state.country.value.name,
		\.slots.feature.id,
		\.slots.feature.value.name
	)
}

// MARK: -
private extension EventLoadFields {
	init(
		id: Event.ID,
		date: Date,
		detailsURL: URL?,
		scoresURL: URL?,
		locationID: Location.ID,
		city: String,
		state: String,
		country: String,
		circuitID: Circuit.ID,
		circuitName: String,
		circuitAbbreviation: String?,
		circuitURL: URL?,
		showID: Show.ID,
		showName: String,
		venueID: Venue.ID,
		venueName: String,
		venueHost: String?,
		venueStreetAddress: String,
		venueZIPCode: String,
		slotIDs: [Slot.ID],
		slotTimes: [Time?],
		performanceIDs: [Performance.ID],
		corpsIDs: [Corps.ID],
		corpsNames: [String],
		corpsURLs: [URL?],
		corpsIsActiveFlags: [Bool],
		corpsLocationIDs: [Location.ID],
		corpsCities: [String],
		corpsStates: [String],
		corpsCountries: [String],
		placementIDs: [Placement.ID],
		ranks: [Int],
		scores: [Double],
		divisionIDs: [Division.ID],
		divisionNames: [String],
		divisionCircuitIDs: [Circuit.ID],
		divisionCircuitNames: [String],
		divisionCircuitAbbreviations: [String?],
		divisionCircuitURLs: [URL?],
		ensembleIDs: [Ensemble.ID],
		ensembleNames: [String],
		ensembleLocationIDs: [Location.ID],
		ensembleCities: [String],
		ensembleStates: [String],
		ensembleCountries: [String],
		featureIDs: [Feature.ID],
		featureNames: [String]
	) {
		self.init(
			id: id,
			date: date,
			detailsURL: detailsURL,
			scoresURL: scoresURL,
			location: .init(
				id: locationID,
				city: city,
				state: state,
				country: country
			),
			circuit: .init(
				id: circuitID,
				name: circuitName,
				abbreviation: circuitAbbreviation,
				url: circuitURL
			),
			show: .init(
				id: showID,
				name: showName
			),
			venue: .init(
				id: venueID,
				name: venueName,
				host: venueHost,
				streetAddress: venueStreetAddress,
				zipCode: venueZIPCode
			),
			slots: slotIDs.enumerated().map { index, id in
				.init(
					id: id,
					time: slotTimes[index],
					performance: .init(
						id: performanceIDs[index],
						corps: .init(
							id: corpsIDs[index],
							name: corpsNames[index],
							url: corpsURLs[index],
							isActive: corpsIsActiveFlags[index],
							location: .init(
								id: corpsLocationIDs[index],
								city: corpsCities[index],
								state: corpsStates[index], 
								country: corpsCountries[index]
							)
						),
						ensemble: .init(
							id: ensembleIDs[index],
							name: ensembleNames[index],
							location: .init(
								id: ensembleLocationIDs[index],
								city: ensembleCities[index],
								state: ensembleStates[index],
								country: ensembleCountries[index]
							)
						),
						placement: .init(
							id: placementIDs[index], 
							rank: ranks[index], 
							score: scores[index],
							division: .init(
								id: divisionIDs[index], 
								name: divisionNames[index],
								circuit: .init(
									id: divisionCircuitIDs[index],
									name: divisionCircuitNames[index],
									abbreviation: divisionCircuitAbbreviations[index],
									url: divisionCircuitURLs[index]
								)
							)
						)
					),
					feature: .init(
						id: featureIDs[index],
						name: featureNames[index]
					)
				)
			}
		)
	}
}
