
import UIKit

protocol IGameViewModelFactory {
    func makeViewModel() -> GameViewModel
}

final class GameViewModelFactory: IGameViewModelFactory {
    
    func makeViewModel() -> GameViewModel {
        let viewModel: GameViewModel = GameViewModel()
        return viewModel
    }
}
