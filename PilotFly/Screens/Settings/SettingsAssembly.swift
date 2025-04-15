
import UIKit

protocol ISettingsAssembly {
    func assemble() -> UIViewController
}

final class SettingsAssembly: ISettingsAssembly {
    private let viewModelFactory: ISettingsViewModelFactory
    
    init(viewModelFactory: ISettingsViewModelFactory = SettingsViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
    
    func assemble() -> UIViewController {
        let presenter: SettingsPresenter = SettingsPresenter(
            viewModelFactory: viewModelFactory
        )
        
        let viewController: SettingsViewController = SettingsViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
