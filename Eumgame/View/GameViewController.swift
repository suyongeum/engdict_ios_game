import UIKit
import SpriteKit
import GameplayKit
import AVKit
import ReactiveCocoa
import ReactiveSwift

class GameViewController: UIViewController {
	@IBOutlet weak var gameView: SKView!
	@IBOutlet weak var sentenceLabel: UILabel!
	@IBOutlet weak var wordLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!
	var viewModel: GameViewModel?
	private var player: AVPlayer?
	private var mainScene: GameScene?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    wordLabel.text = UITextConst.word + ": -"
    pointsLabel.text = UITextConst.score + ": -"
    sentenceLabel.text = ""
    
    mainScene = GameScene(size: gameView.bounds.size)
    mainScene?.viewModel = viewModel
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
  
  override func viewDidDisappear(_ animated: Bool) {
    player?.pause()
    super.viewDidDisappear(animated)
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    mainScene?.touchesBeganFromMainView(touches, with: event)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    mainScene?.touchesMovedFromMainView(touches, with: event)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    mainScene?.touchesEndedFromMainView(touches, with: event)
  }
}

extension GameViewController: GameManagerDelegate {
	func startNewRound() {
		guard let signalProducer = viewModel?.getWord() else { return }
		
		signalProducer.startWithResult({ result in
			result.analysis(ifSuccess: { [weak self] (words) in
				DispatchQueue.main.async {
					self?.showNewSentence()
				}
				}, ifFailure: { (error) in
					//TODO: handle errors
			})
		})
	}
	
	func showNewSentence() {
		guard let viewModel = viewModel else { return }
		
		wordLabel.text = UITextConst.word + ": " + viewModel.userWord.value
		pointsLabel.reactive.text <~ viewModel.pointsString
		sentenceLabel.text = viewModel.sentence.value
		mainScene?.showBallsForSentence()
		playSound(fromUrl: "http://www.uni-english.net:7777/get_audio?content_id=" + String(viewModel.contentId) + "&line_id=" + String(Configuration.shared.lineId))
	}
}
