import ReactiveSwift

class MenuViewModel {
	var flowDelegate: FlowController?
	var contentCount = MutableProperty(0)
  var isLoading = MutableProperty(true)
	
	init() {
    Configuration.shared.content.producer.startWithValues { [weak self] content in
      self?.contentCount.value = content.count
    }
    
    getContent()
	}
  
  func getContent() {
    let signalProducer = AppServerClient.shared.getTopics()
    isLoading.value = true
    signalProducer.startWithResult { result in
      result.analysis(ifSuccess: { [weak self] content in
        Configuration.shared.content.value = content
        self?.isLoading.value = false
        }, ifFailure: { (error) in
      })
    }
  }
	
	func getContentTitleFor(id: Int) -> String {
		return Configuration.shared.content.value[id].name
	}
	
	func startGameForContent(id: Int) {
		flowDelegate?.showGameScreenForContentId(Configuration.shared.content.value[id].id)
	}
}
