
import SpriteKit

let inAppFontName = "gothampro-black"

enum GameType: Equatable {
    case miniGames, mainGame
}

final class TutorialView: SKSpriteNode {
    var touchCompletion: () -> () = { }
    var canTouch = false
    init(gameType: GameType, parent: SKNode, completion: @escaping () -> ()) {
        self.touchCompletion = completion
        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0.9), size: parent.frame.size)
        self.isUserInteractionEnabled = true
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        self.zPosition = ZPositions.cameraElements + 400
        var arrayAct: [SKAction] = []
        let label = SKLabelNode(fontNamed: inAppFontName)
        label.horizontalAlignmentMode = .center
        label.text = "WELCOME!"
        label.fontName = inAppFontName
        label.fontSize = 20
        label.position = CGPoint(x: 0, y: -label.frame.height/2)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 0.9 * frame.width
        addChild(label)
        label.zPosition = self.zPosition + 1
        arrayAct.append(.wait(forDuration: 1))
        let tapText = "TAP TO START"
        
        switch gameType {
        case .miniGames:
            arrayAct.append(.run {
                label.changeTextWithFadeOut(newText: "HOW TO PLAY THIS GAME?")
            })
            
            arrayAct.append(.wait(forDuration: 3.5))
            
            arrayAct.append(.run {
                label.changeTextWithFadeOut(newText: "YOUR TASK IS TO BREAK THE ICE AROUND THE ITEMS IN ORDER TO COLLECT THEM. BE CAREFUL AND DON'T HIT THE BOMBS!")
            })
            
            arrayAct.append(.wait(forDuration: 3.5))
            
        case .mainGame:
            arrayAct.append(.run {
                label.changeTextWithFadeOut(newText: "HOW TO PLAY THIS GAME?")
            })
            
            arrayAct.append(.wait(forDuration: 1.5))
            
            arrayAct.append(.run {
                label.changeTextWithFadeOut(newText: "YOUR OBJECTIVE IS TO CLIMB TO THE VERY TOP OF THE ROOM. YOU CAN TURN INTO ITEMS THAT WILL HELP YOU IF YOU HIT HIM THROWING ARROW. BE CAREFUL AND DON'T GET INTO THE THORNS!")
            })
            
            arrayAct.append(.wait(forDuration: 3.5))
        }
        
        arrayAct.append(.wait(forDuration: 3))
        arrayAct.append(.run {
            label.changeTextWithFadeOut(newText: tapText)
            self.canTouch = true
        })
        self.run(.sequence(arrayAct))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canTouch else { return }
        self.run(.fadeOut(withDuration: 0.5)) {
            self.touchCompletion()
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
