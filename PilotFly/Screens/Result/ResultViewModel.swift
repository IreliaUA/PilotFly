
import UIKit

enum ResultType {
    case win
    case loss
}

struct ResultViewModel {
    let buttonImage: UIImage?
    let mainImage: UIImage?
    let resultType: ResultType
}
