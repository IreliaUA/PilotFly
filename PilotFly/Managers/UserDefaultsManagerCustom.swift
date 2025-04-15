
import Foundation
import UIKit

class UserDefaultsManagerCustom {
    static let shared = UserDefaultsManagerCustom()
    
    var isFirstStartCompleted: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "IsFirstStartCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsFirstStartCompleted")
        }
    }

    var money: Int {
        get {
            return UserDefaults.standard.integer(forKey: "money")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "money")
        }
    }
    
    var bestTime: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "bestTime")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bestTime")
        }
    }
    
    init() { }
}
