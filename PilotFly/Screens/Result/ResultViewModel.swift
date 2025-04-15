
import UIKit

enum ResultType {
    case win
    case loss
}

struct ResultViewModel {
    let bgImage: UIImage?
    let mainImage: UIImage?
    let resultType: ResultType
}
