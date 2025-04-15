
import UIKit

protocol ILevelsAssembly {
    func assemble() -> UIViewController
}

final class LevelsAssembly: ILevelsAssembly {
    private let viewModelFactory: ILevelsViewModelFactory
    
    init(viewModelFactory: ILevelsViewModelFactory = LevelsViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
    
    func assemble() -> UIViewController {
        let presenter = LevelsPresenter(viewModelFactory: viewModelFactory)
        let viewController = LevelsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
