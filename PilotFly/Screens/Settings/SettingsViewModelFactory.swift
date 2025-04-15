
import UIKit

protocol ISettingsViewModelFactory {
    func makeViewModel(
        musicAllowed: Bool,
        soundAllowed: Bool,
        vibrationAllowed: Bool
    ) -> SettingsViewModel
}

final class SettingsViewModelFactory: ISettingsViewModelFactory {
    func makeViewModel(
        musicAllowed: Bool,
        soundAllowed: Bool,
        vibrationAllowed: Bool
    ) -> SettingsViewModel {
        let viewModel: SettingsViewModel = SettingsViewModel(
            musicCheckbox: musicAllowed ? UIImage(named: "onSwitch") : UIImage(named: "offSwitch"),
            soundCheckbox: soundAllowed ? UIImage(named: "onSwitch") : UIImage(named: "offSwitch"),
            vibrationCheckbox: vibrationAllowed ? UIImage(named: "onSwitch") : UIImage(named: "offSwitch")
        )
        return viewModel
    }
}
