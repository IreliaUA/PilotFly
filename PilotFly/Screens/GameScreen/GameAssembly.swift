import UIKit

protocol IGameAssembly {
    func assemble(levelIndex: Int) -> UIViewController
}

final class GameAssembly: IGameAssembly {
    private let viewModelFactory: IGameViewModelFactory

    init(viewModelFactory: IGameViewModelFactory = GameViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }

    func assemble(levelIndex: Int) -> UIViewController {
        let presenter = GamePresenter(viewModelFactory: viewModelFactory, levelIndex: levelIndex)
        let viewController = GameViewController(presenter: presenter, levelIndex: levelIndex)
        presenter.view = viewController
        return viewController
    }
}
