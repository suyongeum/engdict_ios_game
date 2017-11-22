import SpriteKit

class WordBallSprite: SKShapeNode {
	
	convenience init(ballOfRadius radius: CGFloat) {
		self.init(circleOfRadius: radius)
		fillColor = SKColor(red: 172/255, green: 206/255, blue: 0/255, alpha: 1.0)
		physicsBody = SKPhysicsBody(circleOfRadius: radius)
		physicsBody?.affectedByGravity = false
		physicsBody?.categoryBitMask = PhysicsCategories.wordBallCategory
		physicsBody?.isDynamic = false
	}
}
