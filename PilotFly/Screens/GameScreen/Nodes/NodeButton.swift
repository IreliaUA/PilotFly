
import Foundation
import SpriteKit
import AudioToolbox

enum BtnType {
    case back, check, fight, shield, shoot, playMiniGame, set, swap
}

class NodeButton: SKSpriteNode {
    var myType: BtnType!
    var touchesHandler:() -> () = {}
    let numLabel = SKLabelNode(fontNamed: UIFont.boldSystemFont(ofSize: 16).fontName)
    var number: Int = 0 {
        didSet {
            if (number < 0) {
                number = 0
            }
            numLabel.text = "\(number)"
        }
    }
    
    init (type: BtnType) {
        self.myType = type
        super.init(texture: nil, color: .yellow, size: CGSize(width: 50, height: 50))
        self.zPosition = ZPositions.cameraElements
        self.isUserInteractionEnabled = true
        switch type {
        case .check:
            self.texture = SKTexture(imageNamed: "checkButton")
            self.size = CGSize(width: 88, height: 40)
            self.name = "Check"
        case .fight:
            self.size = CGSize(width: 200, height: 78)
            self.texture = SKTexture(imageNamed: "fightButton")
        case .shield:
            self.texture = SKTexture(imageNamed: "shieldBtn")
            self.size = CGSize(width: 60, height: 60)
        case .back:
            self.texture = SKTexture(imageNamed: "backButton")
            self.size = CGSize(width: 50, height: 50)
        case .shoot:
            self.texture = SKTexture(imageNamed: "touchButton")
            self.size = CGSize(width: 50, height: 50)
            self.name = "shoot"
        case .swap:
            self.texture = SKTexture(imageNamed: "swapStateButton")
            self.size = CGSize(width: 50, height: 50)
            self.name = "swap"
        case .playMiniGame:
            self.texture = SKTexture(imageNamed: "continueButton")
            self.size = CGSize(width: 160, height: 60)
            self.name = "MiniGameButton"
        case .set:
            self.texture = SKTexture(imageNamed: "flagButton")
            self.size = CGSize(width: 65, height: 75)
            self.name = "Set"
        default:
            size = CGSize(width: 90, height: 90)
            self.texture = SKTexture(imageNamed: "setBtnImage")
        }
        self.zPosition = ZPositions.cameraElements + 50
        self.alpha = 0
        self.run(.fadeIn(withDuration: 0.5))
    }
    
    func setPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.btn
        //        self.physicsBody?.contactTestBitMask = PhysicsBodies.imageNode
        //        self.physicsBody?.collisionBitMask = PhysicsBodies.imageNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesHandler()
        vibrateSoftly()
        self.run(SKAction.scale(to: 0.9, duration: 0))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.scale(to: 1, duration: 0))
    }
    
    func addNumLabel() {
        let radius:CGFloat = 18
        let circle = SKSpriteNode(texture: SKTexture(imageNamed: "squareBg"), color: .clear, size: CGSize(width: 2*radius, height: 2*radius))
        circle.position = CGPoint(x: frame.width/2, y: frame.height/2)
        circle.zPosition = zPosition + 1
        addChild(circle)
        numLabel.text = "10"
        numLabel.fontSize = 15
        numLabel.fontColor = UIColor.blue
        numLabel.position.y = -numLabel.frame.height/2
        numLabel.zPosition = circle.zPosition + 1
        circle.addChild(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func vibrateSoftly() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .soft)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
}
