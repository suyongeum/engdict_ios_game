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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.backgroundColor = .white
    wordLabel.text = UITextConst.word + ": -"
    
    mainScene = GameScene(size: gameView.bounds.size)
    mainScene?.viewModel = viewModel
    gameView.ignoresSiblingOrder = true
    
    guard let mainScene = mainScene else { return }
    
    mainScene.scaleMode = .aspectFit
    mainScene.gameManagerDelegate = self
    gameView.presentScene(mainScene)
    makeBinding()
    
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
    
    let replayButton = UIBarButtonItem.init(barButtonSystemItem: .reply, target: self, action: #selector(playCurrentSound))
    navigationItem.rightBarButtonItem = replayButton
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let scene = mainScene?.scene else { return }
    
    scene.size = gameView.bounds.size
    mainScene?.setScene()
  }
  
  @objc func playCurrentSound() {
    guard viewModel != nil else { return }
    
    player?.volume = 1.0
    player?.rate = 1.0
    player?.seek(to: kCMTimeZero)
    player?.play()
  }
  
  func makeBinding() {
    guard let viewModel = viewModel else { return }
    
    pointsLabel.reactive.text <~ viewModel.pointsString
    sentenceLabel.reactive.text <~ viewModel.sentence
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    player?.pause()
    viewModel?.clearState()
    super.viewDidDisappear(animated)
  }

  override var prefersStatusBarHidden: Bool {
		return false
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
		mainScene?.showBallsForSentence()
    player = AVPlayer(url: URL(string: viewModel.soundUrl)!)
    playCurrentSound()
	}
}
