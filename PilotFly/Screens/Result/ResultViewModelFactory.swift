
import UIKit

protocol IResultViewModelFactory {
    func makeViewModel(resultType: ResultType) -> ResultViewModel
}

final class ResultViewModelFactory: IResultViewModelFactory {
    
    func makeViewModel(resultType: ResultType) -> ResultViewModel {
        let image: UIImage?
        let buttonImage: UIImage?
        switch resultType {
        case .win:
            image = UIImage(named: "winBg")
            buttonImage = UIImage(named: "okWinButton")
        case .loss:
            image = UIImage(named: "looseBg")
            buttonImage = UIImage(named: "okLooseButton")
        }
        
        let viewModel: ResultViewModel = ResultViewModel(buttonImage: buttonImage, mainImage: image, resultType: resultType)
        return viewModel
    }
}
