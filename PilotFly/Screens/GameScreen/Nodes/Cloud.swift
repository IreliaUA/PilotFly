
import Foundation
import SpriteKit

class Cloud: SKSpriteNode {
    
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "cloud")
        super.init(texture: texture, color: .red, size: size)
    }
    
    func setupPhysics(isLower: Bool = false) {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
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
