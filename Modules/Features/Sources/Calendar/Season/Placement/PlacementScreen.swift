// Copyright © Fleuronic LLC. All rights reserved.

import AppKit
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
		let scoreDelta: Double?
		let scoreDeltaPrefix: String?
		let scoreDeltaPrefixColor: NSColor?
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
		hasSubscreens: Bool,
		scoreDelta: Double? = nil,
		viewItem: @escaping (Any) -> Void,
		showContent: @escaping (String) -> Void
	) {
		let shownEvent = showsEvent ? event : nil
		title = shownEvent?.displayName ?? placement.name
		subtitle = day?.dateString

		let baseScore = Placement.text(forScoreOrDelta: placement.score)
		if let scoreDelta {
			let arrow = scoreDelta >= 0 ? "↑" : "↓"
			let deltaText = Placement.text(forScoreOrDelta: abs(scoreDelta))
			scoreDeltaPrefix = "\(arrow)\(deltaText)"

			let t = min(abs(scoreDelta) / 2, 1)
			let baseColor = NSColor.disabledControlTextColor
			let targetColor: NSColor = scoreDelta >= 0
				? NSColor(red: 0.15, green: 0.5, blue: 0.2, alpha: 1)
				: NSColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
			scoreDeltaPrefixColor = NSColor.interpolate(from: baseColor, to: targetColor, fraction: t)
		} else {
			scoreDeltaPrefix = nil
			scoreDeltaPrefixColor = nil
		}
		scoreText = baseScore

		self.scoreDelta = scoreDelta

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
				hasPlacementSubscreens: false,
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
			showContent: showContent
		) : nil
	}
}

// MARK: -
extension Placement.Screen: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.title == rhs.title && lhs.scoreText == rhs.scoreText && lhs.event.showName == rhs.event.showName
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

// MARK: -
private extension NSColor {
	static func interpolate(from: NSColor, to: NSColor, fraction t: CGFloat) -> NSColor {
		let f = (from.usingColorSpace(.sRGB) ?? from)
		let s = (to.usingColorSpace(.sRGB) ?? to)
		var fr: CGFloat = 0, fg: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
		var sr: CGFloat = 0, sg: CGFloat = 0, sb: CGFloat = 0, sa: CGFloat = 0
		f.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
		s.getRed(&sr, green: &sg, blue: &sb, alpha: &sa)
		return NSColor(
			red: fr + (sr - fr) * t,
			green: fg + (sg - fg) * t,
			blue: fb + (sb - fb) * t,
			alpha: fa + (sa - fa) * t
		)
	}
}
