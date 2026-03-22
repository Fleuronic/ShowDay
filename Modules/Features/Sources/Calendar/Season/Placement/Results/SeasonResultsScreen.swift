// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Event
import struct DrumCorps.Day

extension Placement.SeasonResults {
	struct Screen {
		let title: String
		let detail: String
		let details: [String]
		let placementScreens: [(String?, [Placement.Screen])]
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
		details = content.map(\.1).map { competitions in
			return (competitions.count == 1 ? "1 competition" : "\(competitions.count) competitions")
		}

		placementScreens = content.map { division, placements in
			(
				division?.fullName,
				placements.map { day, event, placement in
					.init(
						placement: placement,
						event: event,
						day: day,
						days: days,
						showsEvent: true,
						isFullResult: true,
						isEmphasized: event == emphasizedEvent,
						hasSubscreens: hasPlacementSubscreens,
						viewItem: viewItem,
						showContent: showContent
					)
				}
			)
		}
	}
}
