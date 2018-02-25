import UIKit

protocol StyleApplier {
    func apply()
}

enum StyleType: String, Codable {
    case blue = "Blue"
    case green = "Green"
    
    var applier: StyleApplier {
        switch self {
        case .blue: return BlueStyle()
        case .green: return GreenStyle()
        }
    }
}

class Style: Equatable, Codable {
    static func ==(lhs: Style, rhs: Style) -> Bool {
        return lhs.styleType == rhs.styleType
    }
    
    enum CodingKeys: String, CodingKey {
        case styleType
    }
    
    private let styleType: StyleType
    
    var name: String {
        return styleType.rawValue
    }
    
    init(styleType: StyleType) {
        self.styleType = styleType
    }
    
    func apply() {
        applyCommonStyling()
        styleType.applier.apply()
        refresh()
    }

    private func refresh() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
            // update the status bar if you change the appearance of it.
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension Style {
    private func applyCommonStyling() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UITabBar.appearance().isTranslucent = false
    }
}
