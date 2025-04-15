import UIKit

final class LevelTableViewCell: UITableViewCell {

    @IBOutlet private weak var levelCellBG: UIImageView!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var levelStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setup(with viewModel: LevelCellModel) {
        levelLabel.text = "Level " + viewModel.levelLabelText
        
        if viewModel.isLocked {
            levelStatusImageView.image = viewModel.levelStatusImage
        } else {
            levelStatusImageView.image = UIImage(named: "normalLevelIcon")
        }
    }
}
