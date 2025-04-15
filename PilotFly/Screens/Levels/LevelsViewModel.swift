
import UIKit

struct LevelsViewModel {
    let cellModels: [LevelCellModel]
}

struct LevelCellModel {
    let number: Int
    let isLocked: Bool
    let levelLabelText: String
    let levelStatusImage: UIImage?
    let alignment: Alignment
}

enum Alignment {
    case left, right
}
