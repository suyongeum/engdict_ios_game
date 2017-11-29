import ReactiveSwift
import Result

class GameViewModel {
	var userWord = MutableProperty("")
	var sentence = MutableProperty("")
	var userWordIndex = MutableProperty(0)
	var totalWordsNumber = MutableProperty(0)
	
	init() {
		userWord <~ Configuration.shared.userWord
		sentence <~ Configuration.shared.wholeSentense
		totalWordsNumber <~ Configuration.shared.totalWordsNumber
		userWordIndex <~ Configuration.shared.userWordIndex
	}
		
	func getWord() -> SignalProducer<Void, AppServerClient.ServerError> {
		return SignalProducer { observer, disposable in
			let signalProducer = AppServerClient.shared.getSentence()
			
			signalProducer.start(){ result in
				switch result {
				case let .value(value):
					Configuration.shared.currentWords = value
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
