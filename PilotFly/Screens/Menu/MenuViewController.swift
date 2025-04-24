
import UIKit

protocol IMenuViewController: UIViewController {
    func setup(with: MenuViewModel)
}

final class MenuViewController: UIViewController {
    
    private let presenter: IMenuPresenter
    
    init(presenter: IMenuPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
        if !SoundsManagerSanctuary.shared.isPlaying {
            SoundsManagerSanctuary.shared.playMenuBackgroundMusicSanctuary()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        sender.vibrateSoftly()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        presenter.showGameScreen()
    }
    
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        sender.vibrateSoftly()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        presenter.showSettingsAncientScreen()
    }
  
}

// MARK: - Extensions

extension MenuViewController: IMenuViewController {
    func setup(with viewModel: MenuViewModel) {
    }
}
