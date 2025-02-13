//
//  File.swift
//  Models
//
//  Created by Jordan Kay on 10/17/25.
//

private import MemberwiseInit

public struct Division: Hashable {
	public let name: String
	public let circuit: Circuit

	private let priority: Int

	public init(
		name: String,
		circuit: Circuit
	) {
		self.name = name
		self.circuit = circuit
	
		priority = Self.names.firstIndex { $0.0 == name && $0.1 == circuit.abbreviation }!
	}
}

// MARK: -
extension Division: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.priority < rhs.priority
	}
}

extension Division: CustomStringConvertible {
	public var description: String {
		name
	}
}

// MARK: -
private extension Division {
	static var names: [(String, String)] {
		[
			("DCI", "DCA"),
			("World Class", "DCI"),
			("Open Class", "DCI"),
			("International Class", "DCI"),
			("All-Age Class", "DCI"),
			("All-Age World Class", "DCI"),
			("All-Age Open Class", "DCI"),
			("All-Age Class A", "DCI"),
			("SoundSport Medalist Division", "DCI"),
			("World Class", "DCA"),
			("Open Class", "DCA"),
			("Class A", "DCA"),
			("Mini-Corps", "DCA"),
			("Open Class", "DCUK"),
			("Premier", "DCUK"),
			("Junior", "DCUK"),
			("Class A", "DCUK")
		]
	}
}
