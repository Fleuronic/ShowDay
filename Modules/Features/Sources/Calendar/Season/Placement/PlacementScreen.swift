

import struct DrumCorps.Placement

extension Placement {
	struct Screen {
		let name: String
		let scoreText: String
		let rankIconName: String
		let rankIconColor: RankIconColor?
	}
}

// MARK: -
extension Placement.Screen {
	enum RankIconColor {
		case gold
		case silver
		case bronze
	}

	init(placement: Placement) {
		name = placement.name
		scoreText = String(format: "%.3f", placement.score)
		rankIconName = "\(placement.rank).circle.fill"
		rankIconColor = .init(medal: placement.medalPlace)
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
