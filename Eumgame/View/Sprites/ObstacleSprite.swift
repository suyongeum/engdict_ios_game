import SpriteKit

class ObstacleSprite: SKShapeNode {
  var movingSpeed: CGFloat = 0.0
  
  convenience init(size: CGSize) {
    self.init(rectOf: size, cornerRadius: 0.0)
    
    fillColor = .darkGray
    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = PhysicsCategories.obstacleCategory
    physicsBody?.isDynamic = false
  }
}
