// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Event
import struct DrumCorps.Day

extension Placement.SeasonResults {
	struct Screen {
		let title: String
		let detail: String
		let placementScreens: [((String, String)?, [Placement.Screen])]
	}
}

// MARK: -
extension Placement.SeasonResults.Screen {
	init(
		days: [Day],
		event: Event,
		placement: Placement,
		hasPlacementSubscreens: Bool,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		let emphasizedEvent = event
		let results = Placement.SeasonResults(
			days: days,
			placement: placement
		)

		let content = results.content

		title = "\(placement.name) Season Results"

		let competitions = content.flatMap(\.1)
		let winCount = competitions.count { $0.2.rank == 1 }
		let winText = winCount == 1 ? "1 win" : (winCount == 0 ? "" : "\(winCount) wins")
		let standing = winCount == competitions.count ? " (undefeated)" : ""

		detail = winText + standing

		placementScreens = content.map { division, placements in
			let detail = placements.count == 1 ? "1 competition" : "\(placements.count) competitions"
			return (
				division.map { ($0.fullName, detail) },
				placements.enumerated().map { index, element in
					let (day, event, placement) = element
					let scoreDelta: Double? = {
						guard index < placements.count - 1 else { return nil }
						return placement.score - placements[index + 1].2.score
					}()

					return Placement.Screen(
						placement: placement,
						event: event,
						day: day,
						days: days,
						showsEvent: true,
						isFullResult: true,
						isEmphasized: event.showName == emphasizedEvent.showName,
						hasSubscreens: hasPlacementSubscreens,
						scoreDelta: scoreDelta,
						viewItem: viewItem,
						showContent: showContent
					)
				}
			)
		}
	}
}

// MARK: -
extension Placement.SeasonResults.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.placementScreens.map(\.1) == rhs.placementScreens.map(\.1)
	}
}
