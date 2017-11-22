import SpriteKit

struct PhysicsCategories {
	static let wordBallCategory : UInt32 = 0x1 << 1
	static let userBallCategory : UInt32 = 0x1 << 2
}

struct Network {
	static let apiUrl = "https://eumgame.com/api"
	static let sentenceMethod = "/sentence"
}

struct JsonKey {
	static let sentence = "sentence"
	static let userWord = "userWord"
	static let soundUrl = "soundUrl"
}

struct GameConfig {
	static let ballRadius: CGFloat = 20.0
	static let screenMargin: CGFloat = 20.0
	static let returnLinePosition: CGFloat = 50.0
}
