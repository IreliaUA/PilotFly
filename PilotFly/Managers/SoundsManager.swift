
import AVFoundation

enum Sounds: String {
    case victorySound = "victorySound.wav"
    case gameOverSound = "gameOverSound.wav"
    
}

class SoundsManagerSanctuary {
    static let shared = SoundsManagerSanctuary()
    
    var isAllowedMusicSanctuary: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsAllowedMusic")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsAllowedMusic")
        }
    }
    
    var isAllowedSoundsSanctuary: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsAllowedSounds")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsAllowedSounds")
        }
    }
    
    var isAllowedVibrationSanctuary: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsAllowedVibration")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsAllowedVibration")
        }
    }
    
    var musicPlayer = AVAudioPlayer()
    var isPlaying = false
    
    var soundPlayer = AVAudioPlayer()
    
    func playMenuBackgroundMusicSanctuary() {
        if isAllowedMusicSanctuary {
            musicPlayer.stop()
            musicPlayer.currentTime = 0
            if let path = Bundle.main.path(forResource: "mainMenuMusic.mp3", ofType: nil) {
                let url = URL(fileURLWithPath: path)
                do {
                    isPlaying = true
                    musicPlayer = try AVAudioPlayer(contentsOf: url)
                    musicPlayer.numberOfLoops = -1
                    musicPlayer.setVolume(0.5, fadeDuration: 1)
                    musicPlayer.play()
                } catch {
                    print("no sound")
                }
            }
        }
    }
    
    func playGameMusicSanctuary() {
        if isAllowedMusicSanctuary {
            if let path = Bundle.main.path(forResource: "gameMusicBG.wav", ofType: nil) {
                
                let url = URL(fileURLWithPath: path)
                
                do {
                    isPlaying = true
                    musicPlayer = try AVAudioPlayer(contentsOf: url)
                    musicPlayer.numberOfLoops = -1
                    musicPlayer.setVolume(0.1, fadeDuration: 1)
                    musicPlayer.play()
                } catch {
                    print("no sound")
                }
            }
        }
    }
    
    func playSoundSanctuary(nameSound: Sounds, isRepeatForever: Bool = false, volume: Float = 0.2) {
        if isAllowedSoundsSanctuary {
            if let path = Bundle.main.path(forResource: nameSound.rawValue, ofType: nil) {
                let url = URL(fileURLWithPath: path)
                do {
                    soundPlayer.stop()
                    soundPlayer.currentTime = 0
                    soundPlayer = try AVAudioPlayer(contentsOf: url)
                    soundPlayer.volume = volume
                    soundPlayer.numberOfLoops = isRepeatForever ? -1 : 0
                    soundPlayer.prepareToPlay()
                    soundPlayer.play()
                } catch {
                    print("no sound")
                }
            }
        }
    }
    
    func stopPlayingSanctuary() {
        musicPlayer.setVolume(0, fadeDuration: 1)
        musicPlayer.stop()
        soundPlayer.setVolume(0, fadeDuration: 1)
        soundPlayer.stop()
        isPlaying = false
    }
}
