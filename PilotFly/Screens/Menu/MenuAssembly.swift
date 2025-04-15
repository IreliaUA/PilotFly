
import UIKit

protocol IMenuAssembly {
    func assemble() -> UIViewController
}

final class MenuAssembly: IMenuAssembly {
    private let viewModelFactory: IMenuViewModelFactory
    
    init(viewModelFactory: IMenuViewModelFactory = MenuViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
    
    func assemble() -> UIViewController {
        let presenter: MenuPresenter = MenuPresenter(
            viewModelFactory: viewModelFactory
        )
        
        let viewController: MenuViewController = MenuViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
