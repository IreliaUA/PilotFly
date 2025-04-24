
import UIKit

protocol ISettingsViewController: AnyObject {
    func setup(with: SettingsViewModel)
}

final class SettingsViewController: UIViewController {
    @IBOutlet weak var soundCheckBox: UIButton!
    @IBOutlet weak var vibrationCheckBox: UIButton!
    @IBOutlet weak var musicCheckBox: UIButton!
    
    private let presenter: ISettingsPresenter
    
    init(presenter: ISettingsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        sender.vibrateSoftly()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func soundCheckBoxAction(_ sender: UIButton) {
        presenter.changeSoundsValue()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        sender.vibrateSoftly()
    }
    
    @IBAction func vibrationCheckBoxAction(_ sender: UIButton) {
        presenter.changeVibrationValue()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        sender.vibrateSoftly()
    }
    
    @IBAction func musicCheckBoxAction(_ sender: UIButton) {
        presenter.changeMusicValue()
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        sender.vibrateSoftly()
    }
}

// MARK: - Extensions

extension SettingsViewController: ISettingsViewController {
    func setup(with viewModel: SettingsViewModel) {
        soundCheckBox.setImage(viewModel.soundCheckbox, for: .normal)
        musicCheckBox.setImage(viewModel.musicCheckbox, for: .normal)
        vibrationCheckBox.setImage(viewModel.vibrationCheckbox, for: .normal)
    }
}
