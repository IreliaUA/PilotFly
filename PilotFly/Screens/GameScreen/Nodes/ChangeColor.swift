
import Foundation
import SpriteKit

class ChangeColor: SKSpriteNode {
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.changeColor
        self.physicsBody?.contactTestBitMask = PhysicsBodies.player
       // self.physicsBody?.collisionBitMask = PhysicsBodies.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
