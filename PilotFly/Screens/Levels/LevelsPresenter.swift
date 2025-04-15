import UIKit

protocol ILevelsPresenter {
    func viewDidLoad()
    func openGameLevel(with number: Int)
    var viewModel: LevelsViewModel? { get }
}

final class LevelsPresenter: ILevelsPresenter {
    
    weak var view: (UIViewController & ILevelsViewController)?
    private let viewModelFactory: ILevelsViewModelFactory
    
    init(viewModelFactory: ILevelsViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    var viewModel: LevelsViewModel?
    
    func viewDidLoad() {
        let createdViewModel = viewModelFactory.makeViewModel()
        viewModel = createdViewModel
        view?.setup(with: createdViewModel)
    }
    
    func openGameLevel(with number: Int) {
        let gameVC = GameAssembly().assemble(levelIndex: number)
        gameVC.modalPresentationStyle = .overFullScreen
        view?.navigationController?.pushViewController(gameVC, animated: true)
    }
}
