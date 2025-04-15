
import UIKit

protocol IResultAssembly {
    func assemble(with type: ResultType, onBackButtonClick: (() -> Void)?) -> UIViewController
}

final class ResultAssembly: IResultAssembly {
    private let viewModelFactory: IResultViewModelFactory
    
    init(viewModelFactory: IResultViewModelFactory = ResultViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
    
    func assemble(with type: ResultType, onBackButtonClick: (() -> Void)?) -> UIViewController {
        let presenter: ResultPresenter = ResultPresenter(
            viewModelFactory: viewModelFactory,
            resultType: type
        )
        
        let viewController: ResultViewController = ResultViewController(
            presenter: presenter,
            resultType: type
        )
        presenter.view = viewController
        presenter.onBackButtonClick = onBackButtonClick
        
        return viewController
    }
}
