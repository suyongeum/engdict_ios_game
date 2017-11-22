import SpriteKit
import ReactiveSwift
import ReactiveCocoa

protocol GameManagerDelegate {
	func startNewRound()
}

class GameScene: SKScene {
    private var userBall: SKShapeNode?
	private var wordsBalls = [WordBallSprite]()
	private var touching: Bool = false
	private var touchPoint: CGPoint = CGPoint()
	private var viewModel = GameViewModel()
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
		let sector = frame.width / CGFloat(viewModel.wordsNumber)
		
		for i in 0..<viewModel.wordsNumber {
			let ball = WordBallSprite(ballOfRadius: GameConfig.ballRadius)
			wordsBalls.append(ball)
			ball.position = CGPoint(x: sector * CGFloat(i) + sector / 2, y: frame.height - GameConfig.ballRadius - GameConfig.screenMargin)
			addChild(ball)
		}
	}
	
	func addUserBall() {
		userBall = UserBallSprite(ballOfRadius: GameConfig.ballRadius)
	
		guard let userBall = userBall else { return }
		
		userBall.position = CGPoint(x: frame.width / 2, y: 0)
		addChild(userBall)
	}
	
	//MARK: - User Interaction
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let location = touch.location(in: self)
		
		guard let userBall = userBall else { return }
		makeUserBall(active: true)
		
		if userBall.frame.contains(location) {
			touchPoint = location
			touching = true
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let location = touch.location(in: self)
		touchPoint = location
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		touching = false
	}
	
	override func update(_ currentTime: TimeInterval) {
		guard let userBall = userBall else { return }

		if touching {
			let dt:CGFloat = 1.0 / 60.0
			let distance = CGVector(dx: touchPoint.x - userBall.position.x, dy: touchPoint.y - userBall.position.y)
			let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
			userBall.physicsBody!.velocity = velocity
		} /*else if 0 < userBall.position.y && userBall.position.y < GameConfig.returnLinePosition { //Return ball to the initial position
			makeUserBall(active: false)
			let action = SKAction.move(to: CGPoint.init(x: frame.width / 2, y: 0), duration: 3.0)
			action.timingMode = .easeInEaseOut
			userBall.run(action)
		}*/
	}
	
	func makeUserBall(active: Bool) {
		userBall?.physicsBody?.affectedByGravity = active
		userBall?.physicsBody?.isDynamic = active
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {	
		if contact.bodyA.categoryBitMask == PhysicsCategories.wordBallCategory {
			(contact.bodyA.node as! WordBallSprite).fillColor = .orange
			
			if wordsBalls.index(of: contact.bodyA.node as! WordBallSprite) == viewModel.searchWordIndex {
				gameManagerDelegate?.startNewRound()
			}
		} else if contact.bodyB.categoryBitMask == PhysicsCategories.wordBallCategory {
			(contact.bodyB.node as! WordBallSprite).fillColor = .orange
			
			if wordsBalls.index(of: contact.bodyB.node as! WordBallSprite) == viewModel.searchWordIndex {
				gameManagerDelegate?.startNewRound()
			}
		}
	}
}
