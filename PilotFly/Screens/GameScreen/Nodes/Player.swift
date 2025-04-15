
import SpriteKit

class Player: SKSpriteNode {
    var playerSpeed: CGFloat = 0.15
    private var shakeActionKey = "shakePlayer"
    
    init() {
        let texture = SKTexture(imageNamed: "plane")
        super.init(texture: texture, color: .red, size: CGSize(width: 300, height: 400))
        self.zPosition = ZPositions.player
        setupPhysics()
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.player
        self.physicsBody?.contactTestBitMask = PhysicsBodies.border | PhysicsBodies.cloud | PhysicsBodies.finishNode | PhysicsBodies.changeColor
        self.physicsBody?.collisionBitMask = PhysicsBodies.border
        self.physicsBody?.mass = 1
        self.name = "Player"
    }
    
    var trail: SKEmitterNode!
    
    func setTrail(targetNode: SKNode) {
        let selectedParticles = "PlaneTail"
        
        if !selectedParticles.isEmpty {
            trail = getParticle(name: selectedParticles, targetNode: targetNode, pos: CGPoint(x: 0, y: -100))
            
            trail.zPosition = self.zPosition - 1
            addChild(trail)
        }
    }
    
    func activateTrail() {
        //        trail.particleBirthRate = 100
    }
    
    func stopTrail() {
        if let trail = trail {
            trail.particleBirthRate = 0
        }
    }
    
    func startShakingPlayer() {
        if action(forKey: shakeActionKey) != nil { return }

        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.05)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.05)
        let shakeSequence = SKAction.sequence([moveUp, moveDown])
        let shakeForever = SKAction.repeatForever(shakeSequence)

        run(shakeForever, withKey: shakeActionKey)
    }

    func stopShakingPlayer() {
        removeAction(forKey: shakeActionKey)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func getParticle(name: String, targetNode: SKNode, pos: CGPoint)-> SKEmitterNode {
    let emitter = SKEmitterNode(fileNamed: name)!
    emitter.position = pos
    emitter.targetNode = targetNode
    return emitter
}
