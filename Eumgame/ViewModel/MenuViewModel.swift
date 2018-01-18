import ReactiveSwift

class MenuViewModel {
	var contentIds = [115, 117, 119, 173, 182, 216, 226, 231]
	var flowDelegate: FlowController?
	var contentCount = MutableProperty(0)
	
	init() {
		contentCount.value = contentIds.count
	}
	
	func getContentTitleFor(id: Int) -> String {
		return "Content ID = " + String(contentIds[id])
	}
	
	func startGameForContent(id: Int) {
		flowDelegate?.showGameScreenForContentId(contentIds[id])
	}
}
