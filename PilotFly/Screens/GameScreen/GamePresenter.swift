
import UIKit

protocol IGamePresenter {
    func showResultVC(resultType: ResultType, onBackButtonClick: (() -> Void)?)
}

final class GamePresenter: IGamePresenter {

    weak var view: IGameViewController?
    private let viewModelFactory: IGameViewModelFactory
    private let levelIndex: Int

    init(viewModelFactory: IGameViewModelFactory, levelIndex: Int) {
        self.viewModelFactory = viewModelFactory
        self.levelIndex = levelIndex
    }

    func showResultVC(resultType: ResultType, onBackButtonClick: (() -> Void)?) {
        if let currentViewController = view?.navigationController?.visibleViewController, currentViewController is ResultViewController {
            return
        } else {
            let resultVC = ResultAssembly().assemble(with: resultType, onBackButtonClick: onBackButtonClick)
            view?.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}
