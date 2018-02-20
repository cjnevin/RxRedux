import Foundation

protocol StyleManaging {
    func set(style: Style)
    func current() -> Style
    func list() -> [Style]
}

class StyleManager: StyleManaging {
    private let userDefaults: UserDefaults
    private let key = "CurrentStyle"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set(style: Style) {
        userDefaults.set(style.name, forKey: key)
        userDefaults.synchronize()
    }
    
    func current() -> Style {
        let styles = list()
        guard let styleName = userDefaults.string(forKey: key) else {
            return styles[0]
        }
        return styles.first(where: { $0.name == styleName }) ?? styles[0]
    }
    
    func list() -> [Style] {
        return [BlueStyle(), GreenStyle()]
    }
}
