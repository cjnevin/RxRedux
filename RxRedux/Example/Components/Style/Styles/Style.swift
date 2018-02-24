import UIKit

class Style: Equatable {
    static func ==(lhs: Style, rhs: Style) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func apply() { fatalError("Must override") }

    func refresh() {
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
    func applyCommonStyling() {
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
