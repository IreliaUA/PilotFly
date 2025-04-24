
import UIKit

extension UIViewController {
    func addChild(_ child: UIViewController, toContainer container: UIView) {
        addChild(child)
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

extension Bool {
    static func touched(lhs: UInt32, rhs: UInt32) -> Bool {
        lhs != 0 && rhs != 0
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        } get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        } get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        } get {
            return layer.borderWidth
        }
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func formattedString() -> String {
        let thousand = self / 1000
        let million = self / 1_000_000
        let billion = self / 1_000_000_000
        let trillion = self / 1_000_000_000_000
        let quadrillion = self / 1_000_000_000_000_000
        
        if quadrillion >= 1.0 {
            return String(format: "%.1fQd", quadrillion)
        } else if trillion >= 1.0 {
            return String(format: "%.1fT", trillion)
        } else if billion >= 1.0 {
            return String(format: "%.1fB", billion)
        } else if million >= 1.0 {
            return String(format: "%.1fM", million)
        } else if thousand >= 1.0 {
            return String(format: "%.1fK", thousand)
        } else {
            return String(format: "%.0f", self)
        }
    }
}

extension UIButton {
    func vibrateSoftly() {
        if SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
    }
}

protocol NibRepresentable {
    static var identifier: String { get }
}

extension UIView: NibRepresentable {
    class var identifier: String {
        return String(describing: self)
    }
}





import SpriteKit

extension SKSpriteNode {
    func setScaleByHeight(texture: SKTexture, newHeight: CGFloat) {
        let newScale = self.xScale * newHeight/self.frame.height
        self.setScale(newScale)
    }
    
    func moveToPoint(to targetPoint: CGPoint) {
        let startPosition: CGPoint = self.position
        self.run(.repeatForever(.sequence([
            .move(to: targetPoint, duration: 1.5),
            .move(to: startPosition, duration: 1.5)
        ])))
    }
    
    func moveToPointBySpeed(speed: CGFloat, targetPoint: CGPoint, actionName: String = "moveToPointWithSpeedAction", completion: @escaping () -> ()) {
        let distance = sqrt(pow(self.position.x - targetPoint.x, 2) + pow(self.position.y - targetPoint.y, 2))
        let duration = abs(distance * 1/(100 * speed))
        print("actionData:distance",distance)
        print("actionData:duration",duration)
        print("actionData:actionName", actionName)
        let action = SKAction.sequence([
            .move(to: targetPoint, duration: duration),
            .run {
                completion()
            }
        ])
        print("actionName", actionName)
        self.run(action, withKey: actionName)
    }
    
    func shake(count: Int, completion: (() -> ())? = nil) {
            var arrActions:[SKAction] = []
            for _ in 0...count - 1 {
                let isUp = Bool.random()
                if (isUp) {
                    let distance: CGFloat = Bool.random() ? 2 : -2
                    arrActions.append(.moveBy(x: 0, y: distance, duration: 0.1))
                    arrActions.append(.moveBy(x: 0, y: -distance, duration: 0.1))
                } else {
                    let distance: CGFloat = Bool.random() ? 2 : -2
                    arrActions.append(.moveBy(x: distance, y: 0, duration: 0.1))
                    arrActions.append(.moveBy(x: -distance, y: 0, duration: 0.1))
                }
            }
            if let completion = completion {
                arrActions.append(.run {
                    completion()
                })
            }
            self.run(.sequence(arrActions))
        }
    
    func changeTextureWithFadeOut(newTexture: SKTexture, newWidth: CGFloat) {
        self.run(.fadeOut(withDuration: 0.2)) {
            self.texture = newTexture
            self.size = self.getSizeByWidth(texture: newTexture, width: newWidth)
            self.run(.fadeIn(withDuration: 0.2))
        }
    }
    
    func getSizeByWidth(texture: SKTexture, width: CGFloat) -> CGSize {
        let ratio = width/texture.size().width
        let size = CGSize(width: width, height: texture.size().height * ratio)
        return size
    }
    
}

extension SKLabelNode {
    
    func startStopwatch() {
        var startTime = Date()
        let updateAction = SKAction.run { [weak self] in
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startTime)
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            self?.text = String(format: "%02dm %02ds", minutes, seconds)
        }
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([updateAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        self.run(repeatAction)
    }
    
    func startTimer(duration: Int, completion: @escaping () -> ()) {
        var arrAct:[SKAction] = []
        for i in 0...duration - 1 {
            let minutes = Int((duration - i)/60)
            let seconds = (duration - i) % 60
            arrAct.append(.run({
                if minutes == 0 {
                    self.text = "\(seconds)s"
                } else {
                    self.text = "\(minutes)m \(seconds)s"
                }
                
            }))
            arrAct.append(.wait(forDuration: 1))
        }
        arrAct.append(.run {
            self.text = "0m 0s"
            completion()
        })
        self.run(.sequence(arrAct))
    }
    
    func changeTextWithFadeOut(newText: String) {
        self.run(.fadeOut(withDuration: 0.3)) {
            self.text = newText
            self.run(.fadeIn(withDuration: 0.3))
        }
    }
}

func getSizeByHeight(texture: SKTexture, height: CGFloat) -> CGSize {
    let ratio = height/texture.size().height
    let size = CGSize(width: texture.size().width * ratio, height: height)
    return size
}


extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx*dx + dy*dy)
        return CGVector(dx: dx/length, dy: dy/length)
    }
}


extension SKCameraNode {
    func shake(count: Int, completion: (() -> ())? = nil) {
        var arrActions:[SKAction] = []
        for _ in 0...count - 1 {
            let isUp = Bool.random()
            if (isUp) {
                let distance: CGFloat = Bool.random() ? 2 : -2
                arrActions.append(.moveBy(x: 0, y: distance, duration: 0.1))
                arrActions.append(.moveBy(x: 0, y: -distance, duration: 0.1))
            } else {
                let distance: CGFloat = Bool.random() ? 2 : -2
                arrActions.append(.moveBy(x: distance, y: 0, duration: 0.1))
                arrActions.append(.moveBy(x: -distance, y: 0, duration: 0.1))
            }
        }
        if let completion = completion {
            arrActions.append(.run {
                completion()
            })
        }
        self.run(.sequence(arrActions))
    }
}

extension UISwitch {
    func vibrateSoftly() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
