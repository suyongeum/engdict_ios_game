import UIKit
import SpriteKit
import GameplayKit
import AVKit

class GameViewController: UIViewController {
	@IBOutlet weak var gameView: SKView!
	@IBOutlet weak var sentenceLabel: UILabel!
	@IBOutlet weak var wordLabel: UILabel!
	private var player: AVPlayer?
	
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
		
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
			print("AVAudioSession Category Playback OK")
			do {
				try AVAudioSession.sharedInstance().setActive(true)
				print("AVAudioSession is Active")
				
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
    }

    override var prefersStatusBarHidden: Bool {
		return false
    }
	
	private func playSound(fromUrl soundUrl: String) {
		player = AVPlayer(url: URL(string: soundUrl)!)
		player?.volume = 1.0
		player?.rate = 1.0
		player?.play()
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
		view.setNeedsLayout()
		playSound(fromUrl: "http://www.uni-english.net:7777/get_audio?content_id=505&line_id=1")
	}
}
