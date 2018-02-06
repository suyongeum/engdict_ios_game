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
	var definition: String?
	
	enum CodingKeys: String, CodingKey {
		case word = "word"
		case difficulty = "difficulty"
		case order = "order"
		case isGap = "is_gap"
		case definition = "definition"
	}
}

struct GuessingWord {
	var wordObject: Word
	var position: Int
}

class Configuration: NSObject {
	static let shared = Configuration()
	
	var wholeSentense = MutableProperty("")
	var totalWordsNumber = MutableProperty(0)
	var userWordIndex = MutableProperty(0)
	var userWord = MutableProperty("")
	var userWordPosition = MutableProperty(0)
	var userWords = [GuessingWord]()
	var lineId = 0
  var content: MutableProperty<[Content]> = MutableProperty([])
		
	var currentWords: Words? {
		didSet {
			guard let words = currentWords?.words else { return }
			clearConfig()
			
			for wordConfig in words {
				if wordConfig.isGap {
					userWords.append(GuessingWord(wordObject: wordConfig, position: totalWordsNumber.value))
					totalWordsNumber.value += 1
					wholeSentense.value = wholeSentense.value  + "(   \(userWords.count)   )"
				} else {
					wholeSentense.value = wholeSentense.value + (wordConfig.word ?? "NIL") + " "
				}
			}
		}
	}
	
	func setCurrentUserWordIndex(_ index: Int) {
		userWordIndex.value = index
		guard !userWords.isEmpty else { return }
		userWord.value = userWords[userWordIndex.value].wordObject.word ?? ""
		userWordPosition.value = userWords[userWordIndex.value].position
	}
	
	func clearConfig() {
		totalWordsNumber.value = 0
		userWords.removeAll()
		wholeSentense.value = ""
		userWordIndex.value = 0
		userWordPosition.value = 0
	}
}
