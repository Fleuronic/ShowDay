// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Event
import struct DrumCorps.Day

extension Placement.SeasonResults {
	struct Screen {
		let title: String
		let subtitle: String
		let placementScreens: [Placement.Screen]
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
		let winText = results.winCount == 1 ? " (1 win)" : (results.winCount == 0 ? "" : " (\(results.winCount) wins)")
		let standing = results.isUndefeated ? " (undefeated)" : winText

		title = "\(placement.name) Season Results"
		subtitle = (content.count == 1 ? "1 competition" : "\(content.count) competitions") + standing
		placementScreens = content.map { day, event, placement in
			.init(
				placement: placement,
				event: event,
				day: day,
				showsEvent: true,
				isEmphasized: event == emphasizedEvent,
				hasSubscreens: hasPlacementSubscreens,
				viewItem: viewItem,
				showContent: showContent
			)
		}
	}
}
