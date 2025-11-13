// Copyright © Fleuronic LLC. All rights reserved.

private import MemberwiseInit

@MemberwiseInit(.public)
public struct Year: Hashable, Sendable {
	public let value: Int
}

// MARK: -
public extension Year {
	static func decades(from startYear: Year, to endYear: Year) -> [Decade] {
		let years = (startYear...endYear).filter { $0.value != 2020 }
		return Dictionary(grouping: years, by: \.startingDecade).sorted { $0.key < $1.key }.map { 
			.init(
				name: "\($0.key)s", 
				years: $0.value
			) 
		}
	}
}

// MARK: -
extension Year: Comparable {
	// MARK: Comparable
	public static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.value < rhs.value
	}
}

extension Year: Strideable {
	// MARK: Strideable
	public func distance(to other: Self) -> Int {
		other.value - value
	}
	
	public func advanced(by n: Int) -> Self {
		.init(value: value + n)
	}
}

extension Year: CustomStringConvertible {
	// MARK: CustomStringConvertible
	public var description: String {
		value.description
	}
}

extension Year: ExpressibleByIntegerLiteral {
	// MARK: ExpressibleByIntegerLiteral
	public init(integerLiteral value: Int) {
		self.value = value
	}
}

// MARK: -
private extension Year {
	var startingDecade: Self {
		.init(value: value / .decadeLength * .decadeLength)
	}
}

// MARK: -
private extension Int {
	static let decadeLength = 10
}
