import Foundation
import ReactiveSwift

struct Words: Codable {
	var words: [Word]
}

struct Word: Codable {
	var word: String?
	var difficulty: Int
	var order: Int
	var isGap: Bool
	var definition: String
	
	enum CodingKeys: String, CodingKey {
		case word = "word"
		case difficulty = "difficulty"
		case order = "order"
		case isGap = "is_gap"
		case definition = "definition"
	}
}

class Configuration: NSObject {
	static let shared = Configuration()
	
	var soundUrl: MutableProperty<String>?
	var wholeSentense = MutableProperty("")
	var totalWordsNumber = MutableProperty(0)
	var userWordIndex = MutableProperty(0)
	var userWord = MutableProperty("")
	var currentGuessingWordIndex = 0
	var userWords = [Word]()
		
	var currentWords: Words? {
		didSet {
			guard let words = currentWords?.words else { return }
			clearConfig()
			
			for wordConfig in words {
				if wordConfig.isGap {
					totalWordsNumber.value += 1
					userWords.append(wordConfig)
					wholeSentense.value = wholeSentense.value  + "(   \(userWords.count)   )"
				} else {
					wholeSentense.value = wholeSentense.value + (wordConfig.word ?? "NIL") + " "
				}
			}
			
			currentGuessingWordIndex = Int(arc4random_uniform(UInt32(userWords.count)))
			userWord.value = userWords[currentGuessingWordIndex].word ?? ""
			userWordIndex.value = currentGuessingWordIndex
		}
	}
	
	private func clearConfig() {
		currentGuessingWordIndex = 0
		totalWordsNumber.value = 0
		userWords.removeAll()
		wholeSentense.value = ""
		userWordIndex.value = 0
	}
}
