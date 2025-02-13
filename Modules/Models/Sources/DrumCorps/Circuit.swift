//
//  File.swift
//  Models
//
//  Created by Jordan Kay on 10/17/25.
//

public import Foundation

private import MemberwiseInit

public struct Circuit: Hashable {
	public let name: String
	public let abbreviation: String?
	public let url: URL?

	private let priority: Int

	public init(
		name: String,
		abbreviation: String?,
		url: URL?
	) {
		self.name = name
		self.abbreviation = abbreviation
		self.url = url

		priority = Self.names.firstIndex(of: name)!
	}
}

// MARK: -
extension Circuit: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.priority < rhs.priority
	}
}

extension Circuit: CustomStringConvertible {
	public var description: String {
		if let abbreviation {
			"\(name) (\(abbreviation))"
		} else {
			name
		}
	}
}

// MARK: -
private extension Circuit {
	static var names: [String] {
		[
			"Drum Corps International",
			"Drum Corps Associates",
			"Drum Corps United Kingdom",
			"Dutch Music Games"
		]
	}
}
