import ReactiveSwift
import Result

class GameViewModel {
	var userWord = MutableProperty("")
	var sentence = MutableProperty("")
	var searchWordIndex = 1
	var wordsNumber = 0
	
	init() {
		userWord <~ Configuration.shared.sentence.value.userWord
		sentence <~  Configuration.shared.sentence.value.sentence
		
		Configuration.shared.sentence.value.sentence.producer.start {newValue in
			let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
			let components = newValue.value?.components(separatedBy: chararacterSet)
			let words = components?.filter { !$0.isEmpty }
			self.wordsNumber = words?.count ?? 0
		}
	}
		
	func getWord() -> SignalProducer<Void, AppServerClient.ServerError> {
		return SignalProducer { observer, disposable in
			let signalProducer = AppServerClient.shared.getSentence()
			signalProducer.start(){ result in
				switch result {
				case let .value(value):
					Configuration.shared.sentence.value.sentence.value = value.sentence
					Configuration.shared.sentence.value.userWord.value = value.userWord
					Configuration.shared.sentence.value.soundUrl.value = value.soundUrl
					observer.sendCompleted()
				case let .failed(error):
					observer.send(error: error)
				default:
					break
				}
				
				//disposable.ended
			}
		}
	}
}
