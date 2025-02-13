//
//  File.swift
//  Services
//
//  Created by Jordan Kay on 10/12/25.
//

public import protocol Catena.ResultProviding

public struct Database: Sendable {
	public init() async {}
}

// MARK: -
extension Database: ResultProviding {
	public typealias Error = Never
}
