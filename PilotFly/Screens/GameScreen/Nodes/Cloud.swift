
import Foundation
import SpriteKit

class Cloud: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(texture: nil, color: .red, size: size)
    }
    
    func setupPhysics(isLower: Bool = false) {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
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
