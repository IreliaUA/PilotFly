
import UIKit

protocol IResultViewModelFactory {
    func makeViewModel(resultType: ResultType) -> ResultViewModel
}

final class ResultViewModelFactory: IResultViewModelFactory {
    
    func makeViewModel(resultType: ResultType) -> ResultViewModel {
        let image: UIImage?
        switch resultType {
        case .win:
            image = UIImage(named: "youWin")
        case .loss:
            image = UIImage(named: "youLose")
        }
        let viewModel: ResultViewModel = ResultViewModel(bgImage: nil, mainImage: image, resultType: resultType)
        return viewModel
    }
}
