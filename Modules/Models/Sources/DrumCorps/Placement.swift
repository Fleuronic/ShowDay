//
//  File.swift
//  Models
//
//  Created by Jordan Kay on 10/12/25.
//

private import MemberwiseInit

@MemberwiseInit(.public)
public struct Placement {
	public let rank: Int
	public let name: String
	public let score: Double
}

// MARK: -
public extension Placement {
	enum MedalPlace: Int {
		case first = 1
		case second = 2
		case third = 3
	}

	var medalPlace: MedalPlace? {
		.init(rawValue: rank)
	}
}

// MARK: -
extension Placement: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rank < rhs.rank
	}
}
