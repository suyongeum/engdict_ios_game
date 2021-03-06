import SpriteKit

struct PhysicsCategories {
	static let wordBallCategory : UInt32 = 0x1 << 1
	static let userBallCategory : UInt32 = 0x1 << 2
  static let obstacleCategory : UInt32 = 0x1 << 3
}

struct Network {
	static let apiUrl = "http://www.uni-english.net:7777"
	static let sentenceMethod = "/wordgaps"
  static let content = "/content"
	static let soundMethod = "/get_audio"
}

struct UrlParameters {
	static let contentId = "content_id"
	static let lineId = "line_id"
	static let difficulty = "difficulty"
}

struct JsonKey {
	static let words = "words"
	static let word = "word"
	static let difficulty = "difficulty"
	static let order = "order"
	static let isGap = "is_gap"
	static let definition = "definition"
}

struct UITextConst {
	static let menu = "Menu"
	static let score = "Score"
	static let word = "Word"
}

struct GameConfig {
	static let ballRadius: CGFloat = 20.0
	static let screenMargin: CGFloat = 20.0
	static let returnLinePosition: CGFloat = 50.0
	static let contentId: Int = 505
	static let difficulty: Int = 3
}
