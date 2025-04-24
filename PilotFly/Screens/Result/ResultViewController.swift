
import UIKit

protocol IResultViewController: AnyObject {
    func setup(with: ResultViewModel)
}

final class ResultViewController: UIViewController {
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var menuButton: UIButton!
    
    private let presenter: IResultPresenter
    private var resultType: ResultType
    
    init(presenter: IResultPresenter, resultType: ResultType) {
        self.presenter = presenter
        self.resultType = resultType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bestTime = UserDefaultsManagerCustom.shared.bestTime
        let minutes = Int(bestTime) / 60
        let seconds = Int(bestTime) % 60
        
        switch resultType {
        case .win:
            
            DispatchQueue.main.async {
                SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .victorySound)
            }
        case .loss:
            
            DispatchQueue.main.async {
                SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .gameOverSound)
            }
        }
        presenter.viewDidLoad()
    }
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
//        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        SoundsManagerSanctuary.shared.playMenuBackgroundMusicSanctuary()
        sender.vibrateSoftly()
        //navigationController?.popToViewController(menuViewController, animated: true)
    
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Extensions

extension ResultViewController: IResultViewController {
    func setup(with viewModel: ResultViewModel) {
        menuButton.setImage(viewModel.buttonImage, for: .normal)
        backGroundImageView.image = viewModel.mainImage
    }
}
