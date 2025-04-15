
import Foundation
import SpriteKit

class Border: SKSpriteNode {
    func setupPhysics(isLower: Bool = false) {
        if isLower {
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height - 600))
        } else {
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height - 100))
        }
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.border
        self.physicsBody?.contactTestBitMask = PhysicsBodies.player
        self.physicsBody?.collisionBitMask = PhysicsBodies.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
