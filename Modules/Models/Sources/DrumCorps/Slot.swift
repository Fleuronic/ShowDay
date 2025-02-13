//
//  File.swift
//  Models
//
//  Created by Jordan Kay on 10/12/25.
//

public import Foundation
public import struct DrumKit.Time

private import MemberwiseInit

@MemberwiseInit(.public)
public struct Slot {
	public let time: Time?
	public let name: String
	public let detail: String?
	public let url: URL?
	public let groupType: GroupType
	public let isGroupActive: Bool?
}

// MARK: -
public extension Slot {
	enum GroupType {
		case corps
		case ensemble
	}

	var timeString: String? {
		time.map {
			Date(timeIntervalSince1970: $0.offset).formatted(
				Date.FormatStyle(
					date: .omitted,
					time: .shortened,
					timeZone: $0.zone
				)
			)
		}
	}
}
