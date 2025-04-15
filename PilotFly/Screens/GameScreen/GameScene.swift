
import SpriteKit
import GameplayKit
import CoreMotion

final class GameScene: SKScene {
    
    weak var gameViewController: IGameViewController?
    var currentLevelIndex: Int = 0
    private var isColorChanged = false
    
    private lazy var cameraNode = SKCameraNode()
    
    private var motionManager: CMMotionManager!
    private var isCanStart: Bool = false
    private var tiltMultiplier: CGFloat = 500
    
    lazy var player: Player = {
        let player: Player = Player()
        player.zPosition = 1000
        return player
    }()
    
    private func setUpScene() {
        setupCamera()
        setupGameNodes()
        setupGame()
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager()
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, error in
                guard let data = data else { return }
                self?.handleTilt(data: data)
            }
        }
    }
    
    private func handleTilt(data: CMAccelerometerData) {
        let tiltX = data.acceleration.x
        var newX = tiltX * tiltMultiplier
        let maxTilt: Double = .pi / 4
        let rotation = -CGFloat(tiltX) * CGFloat(maxTilt)
        let rotateAction = SKAction.rotate(toAngle: rotation, duration: 0.2, shortestUnitArc: true)
        
        let moveAction = SKAction.moveTo(x: newX, duration: 0.2)
        let groupAction = SKAction.group([moveAction])
        player.run(groupAction)
    }
    
    private func setupGame() {
        startGame()
    }
    
    private func startGame() {
        isCanStart = true
        addChild(player)
        
        let wait = SKAction.wait(forDuration: 3.0)
        let moveUp = SKAction.moveBy(x: 0, y: 2, duration: 0.01)
        let startMoving = SKAction.repeatForever(moveUp)
        
        player.run(SKAction.sequence([wait, startMoving]), withKey: "moveUp")
        
        player.setTrail(targetNode: self)
        player.activateTrail()
    }
    
    private func setupCamera() {
        cameraNode.zPosition = 10
        cameraNode.run(.scale(by: 1.8, duration: 0.2))
        addChild(cameraNode)
        
        camera = cameraNode
    }
    
    private func setupGameNodes() {
        children.forEach { child in
            switch child.name {
            case "FinishNode":
                if let finishNode = child as? FinishNode {
                    finishNode.setupPhysics()
                }
                break
            case "Border":
                if let border = child as? Border {
                    border.setupPhysics()
                }
            case "CloudsZone1":
                if let zone = child as? SKSpriteNode {
                    
                    spawnClouds(in: zone)
                    
                    //                    let cloud = Cloud(size: CGSize(width: CGFloat.random(in: 100...500), height:  CGFloat.random(in: 100...500)))
                    //                    cloud.position = CGPoint(x: CGFloat.random(in: zone.frame.minX...zone.frame.maxX) , y: zone.frame.midY)
                }
            case "ChangeColor":
                if let changeColor = child as? ChangeColor {
                    changeColor.setupPhysics()
                    changeColor.zPosition = 10
                }
            default:
                break
            }
        }
    }
    
    private func clearScene() {
        removeAllActions()
        self.run(.wait(forDuration: 0.3)) {
            self.removeAllChildren()
            self.removeFromParent()
        }
    }
    
    private func showResultVC(resultType: ResultType) {
        clearScene()
        if resultType == .win {
            UserDefaultsManagerCustom.shared.money += (self.currentLevelIndex * 100)
            UserDefaults.standard.set(true, forKey: "is\(self.currentLevelIndex)GameLevelCompleted")
        }
    }
    
    
    private func spawnClouds(in zone: SKSpriteNode) {
        let zoneWidth = zone.frame.width
        let zoneHeight = zone.frame.height
        let cloudCount = Int.random(in: 1...3)
        
        let playerSafeZoneWidth: CGFloat = 340
        
        let totalCloudWidth = zoneWidth - playerSafeZoneWidth
        
        let safeZoneStartX = CGFloat.random(in: zone.frame.minX + 50...zone.frame.maxX - 50)
        
        for _ in 0..<cloudCount {
            let cloudWidth = CGFloat.random(in: 100...400)
            let cloudHeight = CGFloat.random(in: 100...400)
            
            var cloudX: CGFloat
            var attempts = 0
            repeat {
                cloudX = CGFloat.random(in: zone.frame.minX...(zone.frame.maxX - cloudWidth))
                attempts += 1
                if attempts > 10 { break }
            } while cloudX < safeZoneStartX + playerSafeZoneWidth && cloudX + cloudWidth > safeZoneStartX
            
            let cloudY = zone.frame.midY
            
            let cloud = Cloud(size: CGSize(width: cloudWidth, height: cloudHeight))
            cloud.position = CGPoint(x: cloudX + cloudWidth/2, y: cloudY)
            cloud.name = "cloud"
            cloud.zPosition = 50
            cloud.setupPhysics()
            
            addChild(cloud)
        }
    }
    
    private func changeBackgroundColor(to color: UIColor) {
        if let bgSprite = childNode(withName: "BgSprite") as? SKSpriteNode {
            let colorOverlay = SKSpriteNode(color: color, size: bgSprite.size)
            colorOverlay.position = bgSprite.position
            colorOverlay.zPosition = bgSprite.zPosition + 1
            colorOverlay.alpha = 0.5
          
            if let existingOverlay = childNode(withName: "ColorOverlay") {
                existingOverlay.removeFromParent()
            }
            
            colorOverlay.name = "ColorOverlay"
            addChild(colorOverlay)
            
            let fadeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
            colorOverlay.run(fadeAction)
        }
    }

    private func changeCloudsColor(to color: UIColor) {
        children.forEach { child in
            if let cloud = child as? Cloud {
                let colorAction = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.5)
                cloud.run(colorAction)
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.parent != nil {
            self.cameraNode.run(.moveTo(y: player.position.y, duration: 0.2))
            //            self.cameraNode.position.y = player.position.y
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.player,
            rhs: secondBody.categoryBitMask & PhysicsBodies.border
        ) {
            //            showResultVC(resultType: .loss)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.player,
            rhs: secondBody.categoryBitMask & PhysicsBodies.cloud
        ) {
            //            showResultVC(resultType: .loss)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.player,
            rhs: secondBody.categoryBitMask & PhysicsBodies.finishNode
        ) {
            //            showResultVC(resultType: .win)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.player,
            rhs: secondBody.categoryBitMask & PhysicsBodies.changeColor
        ) {
//            if !isColorChanged {
                changeBackgroundColor(to: .darkRed)
                changeCloudsColor(to: .darkGray)
//            } else {
//                changeBackgroundColor(to: .clear)
//                changeCloudsColor(to: .clear)
//            }
//            isColorChanged.toggle()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
    }
}

struct ZPositions {
    static let ui: CGFloat = 50
    static let player: CGFloat = 300
    static let cameraElements: CGFloat = 99
    static let miniGames: CGFloat = 250
    static let underMainTextures: CGFloat = -200
    static let textures: CGFloat = -100
}

struct PhysicsBodies {
    static let player: UInt32 = 0x1 << 1
    static let border: UInt32 = 0x1 << 2
    static let btn: UInt32 = 0x1 << 3
    static let finishNode: UInt32 = 0x1 << 4
    static let cloud: UInt32 = 0x1 << 5
    static let changeColor: UInt32 = 0x1 << 6
}
