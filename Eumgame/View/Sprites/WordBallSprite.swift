import SpriteKit

class WordBallSprite: SKShapeNode {
	var label = SKLabelNode(fontNamed: UIFont.boldSystemFont(ofSize: 14).fontName)
	var text:String {
		set {
			label.text = newValue
		}
		
		get {
			return label.text ?? ""
		}
	}
	
	convenience init(ballOfRadius radius: CGFloat) {
		self.init(circleOfRadius: radius)
		fillColor = SKColor(red: 172/255, green: 206/255, blue: 0/255, alpha: 1.0)
		physicsBody = SKPhysicsBody(circleOfRadius: radius)
		physicsBody?.affectedByGravity = false
		physicsBody?.categoryBitMask = PhysicsCategories.wordBallCategory
		physicsBody?.isDynamic = false
		
		label.fontColor = .black
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .center
		label.position = CGPoint(x: 0, y: 0)
		addChild(label)
	}
}
