
import UIKit
import AudioToolbox

protocol ISettingsPresenter {
    func viewDidLoad()
    var viewModel: SettingsViewModel? { get }
    func changeSoundsValue()
    func changeMusicValue()
    func changeVibrationValue()
    var musicAllowValue: Bool { get set }
    var soundAllowValue: Bool { get set }
    var vibrationAllowValue: Bool { get set }
}

final class SettingsPresenter: ISettingsPresenter {
   
    weak var view: ISettingsViewController?
    private let viewModelFactory: ISettingsViewModelFactory
    
    init(
        viewModelFactory: ISettingsViewModelFactory
    ) {
        self.viewModelFactory = viewModelFactory
    }
    
    private func setupViewModel(musicAllowed: Bool, soundsAllowed: Bool, vibrationAllowed: Bool) {
        if UserDefaultsManagerCustom.shared.isFirstStartCompleted {
            let createdViewModel = viewModelFactory.makeViewModel(musicAllowed: musicAllowed, soundAllowed: soundsAllowed, vibrationAllowed: vibrationAllowed)
            viewModel = createdViewModel
            view?.setup(with: createdViewModel)
        } else {
            SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary = true
            SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary = true
            SoundsManagerSanctuary.shared.isAllowedMusicSanctuary = true
            let createdViewModel = viewModelFactory.makeViewModel(
                musicAllowed: SoundsManagerSanctuary.shared.isAllowedMusicSanctuary,
                soundAllowed: SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary,
                vibrationAllowed: SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary
            )
            viewModel = createdViewModel
            view?.setup(with: createdViewModel)
            UserDefaultsManagerCustom.shared.isFirstStartCompleted = true
        }
    }
    
    var musicAllowValue: Bool = SoundsManagerSanctuary.shared.isAllowedMusicSanctuary
    var soundAllowValue: Bool = SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary
    var vibrationAllowValue: Bool = SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary
    
    var viewModel: SettingsViewModel?
    
    func viewDidLoad() {
        setupViewModel(
            musicAllowed: SoundsManagerSanctuary.shared.isAllowedMusicSanctuary,
            soundsAllowed: SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary,
            vibrationAllowed: vibrationAllowValue
        )
    }
    
    func changeSoundsValue() {
        soundAllowValue.toggle()
        SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary = soundAllowValue
        setupViewModel(
            musicAllowed: SoundsManagerSanctuary.shared.isAllowedMusicSanctuary,
            soundsAllowed: soundAllowValue,
            vibrationAllowed: vibrationAllowValue
        )
    }
    
    func changeMusicValue() {
        musicAllowValue.toggle()
        if musicAllowValue {
            SoundsManagerSanctuary.shared.isAllowedMusicSanctuary = musicAllowValue
            SoundsManagerSanctuary.shared.playMenuBackgroundMusicSanctuary()
        } else {
            SoundsManagerSanctuary.shared.stopPlayingSanctuary()
            SoundsManagerSanctuary.shared.isAllowedMusicSanctuary = musicAllowValue
        }
        setupViewModel(
            musicAllowed: musicAllowValue,
            soundsAllowed: SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary,
            vibrationAllowed: vibrationAllowValue
        )
    }
    
    func changeVibrationValue() {
        vibrationAllowValue.toggle()
        if vibrationAllowValue {
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary = vibrationAllowValue
        setupViewModel(
            musicAllowed: SoundsManagerSanctuary.shared.isAllowedMusicSanctuary,
            soundsAllowed: SoundsManagerSanctuary.shared.isAllowedSoundsSanctuary,
            vibrationAllowed: SoundsManagerSanctuary.shared.isAllowedVibrationSanctuary
        )
    }
}
