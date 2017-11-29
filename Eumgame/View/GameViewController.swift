import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	@IBOutlet weak var gameView: SKView!
	@IBOutlet weak var sentenceLabel: UILabel!
	@IBOutlet weak var wordLabel: UILabel!
	
	private var viewModel = GameViewModel()
	private var mainScene: GameScene?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mainScene = GameScene(size: gameView.bounds.size)
		gameView.ignoresSiblingOrder = true
		
		guard let mainScene = mainScene else { return }
		
		mainScene.scaleMode = .resizeFill
		mainScene.gameManagerDelegate = self
		gameView.presentScene(mainScene)
    }

    override var prefersStatusBarHidden: Bool {
		return false
    }
}

extension GameViewController: GameManagerDelegate {
	func startNewRound() {
		let signalProducer = viewModel.getWord()
		
		signalProducer.start() { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .completed:
					self?.showNewSentence()
				case let .failed(error):
					//TODO: handle errors
					break
				default:
					break
				}
			}
		}
	}
	
	func showNewSentence() {
		wordLabel.text = viewModel.userWord.value
		sentenceLabel.text = viewModel.sentence.value
		mainScene?.showBallsForSentence()
		updateViewConstraints()
	}
}
