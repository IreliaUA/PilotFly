
import UIKit
import SwiftUI

protocol IMenuPresenter {
    func viewDidLoad()
    var viewModel: MenuViewModel? { get }
    func showSettingsAncientScreen()
    func showGameScreen()
    func showInfoScreen()
}

final class MenuPresenter: IMenuPresenter {
    weak var view: MenuViewController?
    private let viewModelFactory: IMenuViewModelFactory
    
    init(
        viewModelFactory: IMenuViewModelFactory
    ) {
        self.viewModelFactory = viewModelFactory
    }
    
    var viewModel: MenuViewModel?
    
    func viewDidLoad() {
        let createdViewModel = viewModelFactory.makeViewModel()
        viewModel = createdViewModel
        view?.setup(with: createdViewModel)
    }
    
    func showSettingsAncientScreen() {
        let settingsVC = SettingsAssembly().assemble()
        view?.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func showGameScreen() {
        let mods = LevelsAssembly().assemble()
        view?.navigationController?.pushViewController(mods, animated: true)
    }
    
    func showInfoScreen() {
        let detailExerciseView = InfoView()
        let hostingController = UIHostingController(rootView: detailExerciseView)
        view?.navigationController?.pushViewController(hostingController, animated: true)
    }
}
