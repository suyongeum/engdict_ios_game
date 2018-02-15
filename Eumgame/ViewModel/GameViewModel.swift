import ReactiveSwift
import Result

class GameViewModel {
	var flowDelegate: FlowController?
	var userWord = MutableProperty("")
	var sentence = MutableProperty("-")
	var userWordIndex = MutableProperty(0)
	var totalWordsNumber = MutableProperty(0)
	var userWordPosition = MutableProperty(0)
	var points = MutableProperty(0)
	var pointsString = MutableProperty(UITextConst.score + ": -")
	var contentId = 505
  var soundUrl: String {
    return "http://www.uni-english.net:7777/get_audio?content_id=" + String(contentId) + "&line_id=" + String(Configuration.shared.lineId)
  }
	
	init() {
		userWord <~ Configuration.shared.userWord
		sentence <~ Configuration.shared.wholeSentense
		totalWordsNumber <~ Configuration.shared.totalWordsNumber
		userWordIndex <~ Configuration.shared.userWordIndex
		userWordPosition <~ Configuration.shared.userWordPosition
		points.producer.startWithValues { [weak self] points in
			self?.pointsString.value = UITextConst.score + ": " + String(points)
		}
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
				
				guard let contentId = self?.contentId else { return }
				
				let signalProducer = AppServerClient.shared.getSentence(lineId: Configuration.shared.lineId, contentId: contentId)
				
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
  
  func clearState() {
    Configuration.shared.clearConfig()
  }
}
