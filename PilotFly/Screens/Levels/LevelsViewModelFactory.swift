
import UIKit

protocol ILevelsViewModelFactory {
    func makeViewModel() -> LevelsViewModel
}

final class LevelsViewModelFactory: ILevelsViewModelFactory {
    
    func makeViewModel() -> LevelsViewModel {
        var cellModels: [LevelCellModel] = []
        
        cellModels.append(
            LevelCellModel(
                number: 1,
                isLocked: false,
                levelLabelText: "1",
                levelStatusImage: checkIsCompleted(index: 1),
                alignment: .left
            )
        )
        
        for index in 2...15 {
            cellModels.append(
                LevelCellModel(
                    number: index,
                    isLocked: !UserDefaults.standard.bool(forKey: "is\(index - 1)GameLevelCompleted"),
                    levelLabelText: "\(index)",
                    levelStatusImage: checkIsCompleted(index: index),
                    alignment: index % 2 == 0 ? .right : .left
                )
            )
        }
        
        let viewModel: LevelsViewModel = LevelsViewModel(cellModels: cellModels)
        return viewModel
    }
    
    private func checkIsCompleted(index: Int) -> UIImage? {
        let completedLevelImage: UIImage? = UIImage(named: "completedLevelIcon")
        let notCompletedLevelImage: UIImage? = UIImage(named: "notCompletedLevelIcon")
        var resultImage: UIImage? = UserDefaults.standard.bool(forKey: "is\(index)GameLevelCompleted") ? completedLevelImage : notCompletedLevelImage
        if index == 1 {
            resultImage = UserDefaults.standard.bool(forKey: "is\(index)GameLevelCompleted") ? completedLevelImage : notCompletedLevelImage
            return resultImage
        } else {
            let previousIndex = index - 1
            if UserDefaults.standard.bool(forKey: "is\(index)GameLevelCompleted") {
                return completedLevelImage
            } else {
                let isPreviousCompleted = UserDefaults.standard.bool(forKey: "is\(previousIndex)GameLevelCompleted")
                if isPreviousCompleted {
                    return notCompletedLevelImage
                } else {
                    return UIImage(named: "notCompletedLevelIcon")
                }
            }
        }
    }
}
