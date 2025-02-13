// Copyright © Fleuronic LLC. All rights reserved.

import DrumKit
import DrumKitAPI
public import enum Catenary.Error
public import enum Catenary.Request
public import struct Caesura.EndpointAPI
public import protocol Caesura.Endpoint
public import protocol Catena.ResultProviding

public struct API<Endpoint: Caesura.Endpoint>: Sendable {
	let drumKitAPI: DrumKitAPI.API<
		Endpoint,
		EventLoadFields,
		DrumKit.Location.IDFields,
		DrumKit.State.IDFields,
		DrumKit.Country.IDFields,
		DrumKit.Circuit.IDFields,
		DrumKit.Show.IDFields,
		DrumKit.Venue.IDFields,
		DrumKit.Address.IDFields,
		DrumKit.ZIPCode.IDFields,
		DrumKit.Feature.IDFields,
		DrumKit.Ensemble.IDFields,
		DrumKit.Corps.IDFields,
		DrumKit.Division.IDFields
	>
}

public extension API<EndpointAPI> {
	init() {
		self.init(drumKitAPI: .init(apiKey: .apiKey))
	}
}

// MARK: -
extension API: ResultProviding {
	public typealias Error = Catenary.Error<Request.Error>
}

// MARK: -
private extension String {
	static let apiKey = "B7yNhxTpV5iNSGQQeZ3c26wPqPo6lyqSbPoYD41U5UEuhHMuEidpaZ3AkBLIG8xm"
}
