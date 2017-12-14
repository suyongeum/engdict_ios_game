import SpriteKit
import ReactiveSwift
import ReactiveCocoa

protocol GameManagerDelegate {
	func startNewRound()
}

class GameScene: SKScene {
	enum State {
		case paused, roundInProgress, touching
	}
	
    private var userBall: SKShapeNode?
	private var wordsBalls = [WordBallSprite]()
	private var touchPoint: CGPoint = CGPoint()
	private var viewModel = GameViewModel()
	private var state: State = .paused
	var gameManagerDelegate: GameManagerDelegate?
	
    override func didMove(to view: SKView) {
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		backgroundColor = SKColor.white
		physicsWorld.contactDelegate = self
		addUserBall()
		gameManagerDelegate?.startNewRound()
    }
	
	//MARK: - Elements creation

	func showBallsForSentence() {
		for wordBall in wordsBalls {
			wordBall.removeFromParent()
		}
		
		wordsBalls.removeAll()
		let sector = frame.width / CGFloat(viewModel.totalWordsNumber.value)
		
		for i in 0..<viewModel.totalWordsNumber.value {
			let ball = WordBallSprite(ballOfRadius: GameConfig.ballRadius)
			ball.text = String(i + 1)
			wordsBalls.append(ball)
			ball.position = CGPoint(x: sector * CGFloat(i) + sector / 2, y: frame.height - GameConfig.ballRadius * 2)
			addChild(ball)
		}
	}
	
	func addUserBall() {
		userBall = UserBallSprite(ballOfRadius: GameConfig.ballRadius)
		guard let userBall = userBall else { return }
		userBall.position = CGPoint(x: frame.width / 2, y: userBall.frame.height / 2)
		addChild(userBall)
	}
	
	//MARK: - User Interaction
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard state != .paused else { return }
		state = .touching
		let touch = touches.first!
		let location = touch.location(in: self)
		userBall?.physicsBody?.isDynamic = true
		userBall?.physicsBody?.affectedByGravity = true
		
		guard let userBall = userBall else { return }
		
		if userBall.frame.contains(location) {
			touchPoint = location
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let location = touch.location(in: self)
		touchPoint = location
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		state = .roundInProgress
	}
	
	//MARK: - Main game cycle
	
	override func update(_ currentTime: TimeInterval) {
		guard let userBall = userBall else { return }

		switch state {
		case .touching:
			let dt: CGFloat = 1.0 / 60.0
			let distance = CGVector(dx: touchPoint.x - userBall.position.x, dy: touchPoint.y - userBall.position.y)
			let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
			userBall.physicsBody!.velocity = velocity
		case .roundInProgress:
			if userBall.position.y < 40 && userBall.physicsBody!.velocity.dy < 0 {
				userBall.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
				userBall.physicsBody?.isDynamic = false
				userBall.physicsBody?.affectedByGravity = false
				let moveToInitPosition = SKAction.move(to: CGPoint(x: frame.width / 2, y: userBall.frame.height / 2), duration: 0.3)
				userBall.run(moveToInitPosition)
			}
		case .paused:
			userBall.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
			let dissappear = SKAction.fadeAlpha(to: 0, duration: 0.2)
			let appear = SKAction.fadeAlpha(to: 1, duration: 0.2)
			userBall.physicsBody?.isDynamic = false
			userBall.physicsBody?.affectedByGravity = false
			
			userBall.run(dissappear) {
				let moveToInitPosition = SKAction.move(to: CGPoint(x: self.frame.width / 2, y: userBall.frame.height / 2), duration: 0.0)
				userBall.run(moveToInitPosition)
				userBall.run(appear)
			}
		}
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		guard state != .paused else { return }
		var body: WordBallSprite?
		
		if contact.bodyA.categoryBitMask == PhysicsCategories.wordBallCategory {
			body = contact.bodyA.node as? WordBallSprite
		} else if contact.bodyB.categoryBitMask == PhysicsCategories.wordBallCategory {
			body = contact.bodyB.node as? WordBallSprite
		}
		
		guard let ball = body else { return }
		ball.fillColor = .orange
		
		if wordsBalls.index(of: ball) == viewModel.userWordIndex.value {
			state = .paused
			gameManagerDelegate?.startNewRound()
		}
	}
}
