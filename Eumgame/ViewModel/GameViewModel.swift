import ReactiveSwift
import Result

class GameViewModel {
	var userWord = MutableProperty("")
	var sentence = MutableProperty("")
	var userWordIndex = MutableProperty(0)
	var totalWordsNumber = MutableProperty(0)
	var userWordPosition = MutableProperty(0)
	
	init() {
		userWord <~ Configuration.shared.userWord
		sentence <~ Configuration.shared.wholeSentense
		totalWordsNumber <~ Configuration.shared.totalWordsNumber
		userWordIndex <~ Configuration.shared.userWordIndex
		userWordPosition <~ Configuration.shared.userWordPosition
	}
		
	func getWord() -> SignalProducer<Void, AppServerClient.ServerError> {
		return SignalProducer { [weak self] observer, disposable in
			if !Configuration.shared.userWords.isEmpty {
				Configuration.shared.userWords.remove(at: Configuration.shared.userWordIndex.value)
			}
			
			if !Configuration.shared.userWords.isEmpty {
				if let randomIndex = self?.randomGuessingWordIndex() {
					Configuration.shared.setCurrentUserWordIndex(randomIndex)
					observer.send(value: ())
					observer.sendCompleted()
				}
			} else {
				Configuration.shared.lineId += 1
				
				if Configuration.shared.lineId > 6 {
					Configuration.shared.lineId = 1
				}
				
				let signalProducer = AppServerClient.shared.getSentence(lineId: Configuration.shared.lineId)
				
				signalProducer.startWithResult { result in
					result.analysis(ifSuccess: { [weak self] (words) in
						Configuration.shared.currentWords = words
						if let randomIndex = self?.randomGuessingWordIndex() {
							Configuration.shared.setCurrentUserWordIndex(randomIndex)
							observer.send(value: ())
							observer.sendCompleted()
						}
					}, ifFailure: { (error) in
						observer.send(error: error)
					})
				}
			}
		}
	}
	
	private func randomGuessingWordIndex() -> Int {
		return Int(arc4random_uniform(UInt32(Configuration.shared.userWords.count)))
	}
}
