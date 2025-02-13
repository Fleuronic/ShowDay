// Copyright © Fleuronic LLC. All rights reserved.

public import MapKit

private import CoreLocation
private import MemberwiseInit

@_UncheckedMemberwiseInit(.public)
public struct Venue {
	private let name: String
	private let host: String?
	private let streetAddress: String
	private let location: Location
	private let zipCode: String
}

// MARK: -
public extension Venue {
	var details: [String] {
		[
			name,
			host,
			streetAddress,
			"\(location) \(zipCode)"
		].compactMap(\.self)
	}

	@MainActor
	var mapItem: MKMapItem {
		get async {
			let addressString = "\(streetAddress), \(location) \(zipCode)"
			let placemark = try! await CLGeocoder().geocodeAddressString(addressString).first!
			let mapItem = MKMapItem(placemark: .init(placemark: placemark))
			mapItem.name = name
			return mapItem
		}
	}
}
