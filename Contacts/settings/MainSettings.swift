import Foundation

private let mainSettingsInstance = MainSettings()

final class MainSettings: NSObject {
    
    private static let mainSettingsDictionaryTitle = "MainSettings"
    
    private let defaults: UserDefaults
    
    private var mainSettingsDictionary: [String : Any] {
        get {
            return defaults.dictionary(forKey: MainSettings.mainSettingsDictionaryTitle) ?? [:]
        }
        set {
            defaults.set(newValue, forKey: MainSettings.mainSettingsDictionaryTitle)
        }
    }
    
    fileprivate override init() {
        defaults = .standard
        super.init()
    }
    
    private enum Key: String {
        case shouldFillDatabase
    }
    
}

extension MainSettings {
    
    static var shared: MainSettings {
        get {
            return mainSettingsInstance
        }
    }
    
    var shouldFillDatabase: Bool {
        get {
            return mainSettingsDictionary[Key.shouldFillDatabase.rawValue] as? Bool ?? true
        }
        set {
            mainSettingsDictionary[Key.shouldFillDatabase.rawValue] = newValue
        }
    }
    
}
