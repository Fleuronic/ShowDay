// Copyright © Fleuronic LLC. All rights reserved.

public import Foundation

private import MemberwiseInit

/// An event held as part of a drum corps season.
@MemberwiseInit(.public)
public struct Event {
	public let location: Location
	public let circuit: Circuit?
	public let showName: String?
	public let venue: Venue?
	public let slots: [Slot]
	public let placements: [(Division?, [Placement])]
	public let detailsURL: URL?
	public let scoresURL: URL?
}

// MARK: -
public extension Event {
	var details: [String] {
		venue?.details ?? [location.description]
	}

	var topPlacements: [Placement] {
		placements.first.map { Array($0.1.prefix(3)) } ?? []
	}

	var displayName: String {
		showDisplayName ?? location.description
	}

	var showDisplayName: String? {
		showName.map { name in
			[
				"Diablo Valley Classic",
				"So Cal Classic",
				"Rhythm at the Rapids",
				"Drum Corps: An American Tradition",
				"Innovations in Brass",
				"Tour of Champions"
			].first {
				name.contains($0)
			} ?? name
		}
	}
}

// MARK: -
extension Event: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		// TODO
		lhs.showName == rhs.showName
	}
}
