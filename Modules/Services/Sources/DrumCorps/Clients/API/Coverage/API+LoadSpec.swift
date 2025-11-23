// Copyright © Fleuronic LLC. All rights reserved.

public import DrumCorps
public import protocol DrumCorpsService.LoadSpec
public import protocol Catena.ResultProviding
public import struct DrumCorpsService.EventCircuitLoadFields

extension API: LoadSpec {
	public func loadDays(in year: Year, excluding circuits: Set<Circuit>) async -> Results<Day> {
		await drumKitAPI
			.listEvents(for: year.value, excludingCircuitsNamed: circuits.map(\.name))
			.map { fields in
				let tuples = fields.map { fields in
					let location = Location(
						city: fields.location.city,
						state: fields.location.state,
						country: fields.location.country
					)

					let pairs = fields.slots.map { slot in
						let performance = slot.performance
						let corps = performance?.corps
						let ensemble = performance?.ensemble
						let groupName = corps?.name ?? ensemble?.name
						let featureGroup = slot.feature.map { _ in groupName }

						let location = (corps?.location ?? ensemble?.location).map {
							Location(
								city: $0.city,
								state: $0.state,
								country: $0.country
							)
						}

						return (
							slot: Slot(
								time: slot.time, 
								name: slot.feature?.name ?? groupName!,
								detail: featureGroup ?? location?.description,
								url: corps?.url,
								groupType: corps != nil ? .corps : .ensemble,
								isGroupActive: slot.feature == nil ? (corps?.isActive ?? true) : nil
							),
							placement: (performance?.placement).map { placement in
								(placement, groupName!)
							}
						)
					}

					let placements = Dictionary(grouping: pairs.compactMap(\.placement), by: \.0.division).map {
						(
							$0.map {
								Division(
									name: $0.name,
									circuit: .init(
										name: $0.circuit.name,
										abbreviation: $0.circuit.abbreviation,
										url: $0.circuit.url
									)
								)
							},
							$1.map { placement, groupName in
								Placement(
									rank: placement.rank,
									name: groupName,
									score: placement.score
								)
							}.sorted()
						)
					}.sorted {
						if let lhs = $0.0, let rhs = $1.0 {
							lhs < rhs
						} else {
							false
						}
					}
					
					return (
						date: fields.date,
						firstSlotTime: fields.slots.first?.time,
						event: Event(
							location: location,
							circuit: fields.circuit.map { circuit in
								.init(
									name: circuit.name,
									abbreviation: circuit.abbreviation,
									url: circuit.url
								)
							},
							showName: fields.show?.name,  
							venue: fields.venue.map { venue in
								.init(
									name: venue.name,
									host: venue.host,
									streetAddress: venue.streetAddress,
									location: location,
									zipCode: venue.zipCode
								)
							},
							slots: pairs.map(\.slot),
							placements: placements,
							detailsURL: fields.detailsURL,
							scoresURL: fields.scoresURL
						)
					)
				}

				return Dictionary(grouping: tuples, by: \.date)
					.map { ($0, $1.map { ($0.firstSlotTime, $0.event) }) }
					.sorted { $0.0 > $1.0 }
					.map { date, pairs in
						.init(
							date: date,
							events: pairs.sorted {
								if let lhs = $0.0, let rhs = $1.0 {
									lhs > rhs
								} else if let lhs = $0.1.showName, let rhs = $1.1.showName {
									lhs < rhs
								} else {
									false
								}
							}.map(\.1)
						)
					}
			}
	}

	public func loadCircuits(in year: Year) async -> Results<Circuit> {
		await drumKitAPI
			.specifyingEventFields(EventCircuitLoadFields.self)
			.listEvents(for: year.value)
			.map { fields in
				let circuitSet = Set(
					fields.compactMap { fields in
						fields.circuit.map {
							Circuit(
								name: $0.name,
								abbreviation: $0.abbreviation,
								url: nil
							)
						}
					}
				)

				return Array(circuitSet).sorted()
			}
	}
}
