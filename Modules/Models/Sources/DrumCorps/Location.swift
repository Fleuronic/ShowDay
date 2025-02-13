// Copyright © Fleuronic LLC. All rights reserved.

public import MapKit

private import CoreLocation
private import MemberwiseInit

@MemberwiseInit(.public)
public struct Location: Equatable {
	public let city: String
	public let state: String
	public let country: String
}

// MARK: -
extension Location: CustomStringConvertible {
	public var description: String {
		["United States", "Canada"].contains(country) ? "\(city), \(state)" : "\(city), \(country)"
	}
}

// MARK: -
public extension Location {
	@MainActor
	var mapItem: MKMapItem {
		get async {
			let placemark = try! await CLGeocoder().geocodeAddressString(description).first!
			let mapItem = MKMapItem(placemark: .init(placemark: placemark))
			mapItem.name = description
			return mapItem
		}
	}
}
