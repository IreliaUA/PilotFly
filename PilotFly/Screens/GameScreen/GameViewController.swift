import UIKit
import SpriteKit

protocol IGameViewController: UIViewController {
    func goBack()
    func goToMenu()
    func showResultVC(resultType: ResultType, onBackButtonClick: (() -> Void)?)
}

final class GameViewController: UIViewController {

    private let presenter: IGamePresenter
    private let levelIndex: Int

    init(
        presenter: IGamePresenter,
        levelIndex: Int
    ) {
        self.presenter = presenter
        self.levelIndex = levelIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        if let view = self.view as? SKView {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                scene.size = UIScreen.main.bounds.size
                scene.gameViewController = self
                scene.currentLevelIndex = levelIndex

                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            view.showsPhysics = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension GameViewController: IGameViewController {
    func goBack() {
        if let navController = self.navigationController {
            SoundsManagerSanctuary.shared.playMenuBackgroundMusicSanctuary()
            navController.popViewController(animated: false)
        }
    }

    func goToMenu() {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuAssembly }) {
            SoundsManagerSanctuary.shared.playMenuBackgroundMusicSanctuary()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }

    func showResultVC(resultType: ResultType, onBackButtonClick: (() -> Void)? = nil) {
        presenter.showResultVC(resultType: resultType, onBackButtonClick: onBackButtonClick)
    }
}
