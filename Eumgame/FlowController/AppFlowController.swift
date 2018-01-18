import UIKit

protocol FlowController {
	func showGameScreenForContentId(_ contentId: Int)
}

class AppFlowController {
	private let navigationController: UINavigationController
	
	init(with navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewModel = MenuViewModel()
		viewModel.flowDelegate = self
		let menuVC = MenuTableViewController()
		menuVC.viewModel = viewModel
		navigationController.show(menuVC, sender: nil)
	}
}

extension AppFlowController: FlowController {
	func showGameScreenForContentId(_ contentId: Int) {
		let viewModel = GameViewModel()
		viewModel.flowDelegate = self
		viewModel.contentId = contentId
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let gameVC = storyboard.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
		gameVC.viewModel = viewModel
		navigationController.pushViewController(gameVC, animated: true)
	}
}
