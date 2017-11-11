//
//  GameScene.swift
//  Eumgame
//
//  Created by Elena Kapilevich on 10/26/17.
//  Copyright © 2017 KinakoInc. All rights reserved.
//

import SpriteKit
import ReactiveSwift
import ReactiveCocoa

class GameScene: SKScene {
	//TODO: FIX unwrapping
    private var wordLabel: SKLabelNode!
    private var userBall: SKShapeNode!
	private var wordsBalls = [WordBallSprite]()
	private var touching: Bool = false
	private var touchPoint: CGPoint = CGPoint()
	private var viewModel = GameViewModel()

    override func didMove(to view: SKView) {
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		backgroundColor = SKColor.white
		physicsWorld.contactDelegate = self
		
		userBall = UserBallSprite(ballOfRadius: GameConfig.ballRadius)
		userBall.position = CGPoint(x: frame.width / 2, y: 0)
		addChild(userBall)
		
		startNewRound()
    }
	
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
		for wordBall in wordsBalls {
			wordBall.removeFromParent()
		}
		
		wordsBalls.removeAll()
		wordLabel?.removeFromParent()
		
		let sector = frame.width / CGFloat(viewModel.wordsNumber)
		
		for i in 0..<viewModel.wordsNumber {
			let ball = WordBallSprite(ballOfRadius: GameConfig.ballRadius)
			wordsBalls.append(ball)
			ball.position = CGPoint(x: sector * CGFloat(i) + sector / 2, y: frame.height - GameConfig.ballRadius - GameConfig.screenMargin)
			addChild(ball)
		}
		
		addWordLabel()
	}
	
	func addWordLabel() {
		wordLabel = SKLabelNode(fontNamed: "Chalkduster")
		//wordLabel.reactive.makeBindingTarget{$0.text = $1} <~ viewModel.userWord
		wordLabel.text = viewModel.userWord.value
		wordLabel.fontColor = .black
		wordLabel.horizontalAlignmentMode = .right
		wordLabel.position = CGPoint(x: frame.width, y: GameConfig.screenMargin)
		addChild(wordLabel)
	}
	
	//MARK: - User Interaction
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let location = touch.location(in: self)
		
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
		if touching {
			let dt:CGFloat = 1.0 / 60.0
			let distance = CGVector(dx: touchPoint.x - userBall.position.x, dy: touchPoint.y - userBall.position.y)
			let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
			userBall.physicsBody!.velocity = velocity
		}
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {	
		if contact.bodyA.categoryBitMask == PhysicsCategories.wordBallCategory {
			(contact.bodyA.node as! WordBallSprite).fillColor = .orange
			
			if wordsBalls.index(of: contact.bodyA.node as! WordBallSprite) == viewModel.searchWordIndex {
				startNewRound()
			}
		} else if contact.bodyB.categoryBitMask == PhysicsCategories.wordBallCategory {
			(contact.bodyB.node as! WordBallSprite).fillColor = .orange
			
			if wordsBalls.index(of: contact.bodyB.node as! WordBallSprite) == viewModel.searchWordIndex {
				startNewRound()
			}
		}
	}
}
