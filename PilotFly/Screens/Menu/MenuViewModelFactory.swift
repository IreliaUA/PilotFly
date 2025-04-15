
import UIKit

protocol IMenuViewModelFactory {
    func makeViewModel() -> MenuViewModel
}

final class MenuViewModelFactory: IMenuViewModelFactory {
    
    func makeViewModel() -> MenuViewModel {
        let viewModel: MenuViewModel = MenuViewModel()
        return viewModel
    }
}
