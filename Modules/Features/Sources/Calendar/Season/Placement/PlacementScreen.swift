// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumCorps.Placement
import struct DrumCorps.Event
import struct DrumCorps.Day

extension Placement {
	struct Screen {
		let placement: Placement
		let event: Event
		let title: String
		let subtitle: String?
		let scoreText: String
		let rankIconName: String
		let rankIconColor: RankIconColor?
		let days: [Day]?
		let isFullResult: Bool
		let isEmphasized: Bool
		let viewScores: () -> Void
		let viewItem: (Any) -> Void
		let showContent: (String) -> Void

		private let hasSubscreens: Bool
	}
}

// MARK: -
extension Placement.Screen {
	enum RankIconColor {
		case gold
		case silver
		case bronze
	}

	init(
		placement: Placement,
		event: Event,
		day: Day? = nil,
		days: [Day]? = nil,
		showsEvent: Bool = false ,
		isFullResult: Bool = false,
		isEmphasized: Bool = false,
		hasSubscreens: Bool = true,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		let shownEvent = showsEvent ? event : nil
		title = shownEvent?.displayName ?? placement.name
		subtitle = day?.dateString
		scoreText = String(format: "%.3f", placement.score)
		rankIconName = "\(placement.rank).circle.fill"
		rankIconColor = .init(medal: placement.medalPlace)
		viewScores = { viewItem((event, [placement])) }

		self.placement = placement
		self.event = event
		self.days = days
		self.isFullResult = isFullResult
		self.isEmphasized = isEmphasized
		self.viewItem = viewItem
		self.showContent = showContent
		self.hasSubscreens = hasSubscreens
	}

	var seasonResultsScreen: Placement.SeasonResults.Screen? {
		days.map {
			.init(
				days: $0,
				event: event, // TODO
				placement: placement,
				viewItem: viewItem,
				showContent: showContent
			)
		}
	}

	var eventResultsScreen: Event.Results.Screen? {
		hasSubscreens ? .init(
			event: event,
			days: days,
			placement: placement,
			viewItem: viewItem,
			hasPlacementSubscreens: false,
			showContent: showContent
		) : nil
	}
}

// MARK: -
extension Placement.Screen.RankIconColor {
	init?(medal: Placement.MedalPlace?) {
		switch medal {
		case .first: self = .gold
		case .second: self = .silver
		case .third: self = .bronze
		default: return nil
		}
	}
}
