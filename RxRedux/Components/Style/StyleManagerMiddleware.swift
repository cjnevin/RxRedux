import UIKit

class Style: Equatable {
    static func ==(lhs: Style, rhs: Style) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func apply() { }
    func unapply() { }
    
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

class BlueStyle: Style {
    init() {
        super.init(name: "Blue")
    }
    
    override func apply() {
        UIButton.appearance().tintColor = UIColor.rgb(11, 42, 62)
        UIButton.appearance().setTitleColor(UIColor.rgb(174, 219, 245), for: .normal)
        UIButton.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = UIColor.rgb(174, 219, 245)
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
        background.backgroundColor = UIColor.rgb(5, 32, 60)
        let renderer = UIGraphicsImageRenderer(size: background.bounds.size)
        let image = renderer.image { ctx in
            background.drawHierarchy(in: background.bounds, afterScreenUpdates: true)
        }
        
        UIApplication.shared.keyWindow?.tintColor = UIColor.rgb(53, 107, 141)
        UIApplication.shared.statusBarStyle = .lightContent
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.rgb(135, 185, 218)
        UITabBar.appearance().tintColor = UIColor.rgb(53, 107, 141)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundImage = image
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        UINavigationBar.appearance().tintColor = UIColor.rgb(53, 107, 141)
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
    }
}

class GreenStyle: Style {
    init() {
        super.init(name: "Green")
    }
    
    override func apply() {
        UIButton.appearance().tintColor = UIColor.rgb(79, 176, 112)
        UIButton.appearance().setTitleColor(UIColor.rgb(222, 247, 229), for: .normal)
        UIButton.appearance().backgroundColor = UIColor.rgb(56, 113, 66)
        
        UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = UIColor.rgb(222, 247, 229)
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
        background.backgroundColor = UIColor.rgb(56, 113, 66)
        let renderer = UIGraphicsImageRenderer(size: background.bounds.size)
        let image = renderer.image { ctx in
            background.drawHierarchy(in: background.bounds, afterScreenUpdates: true)
        }
        
        UIApplication.shared.keyWindow?.tintColor = UIColor.rgb(163, 232, 178)
        UIApplication.shared.statusBarStyle = .lightContent
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.rgb(107, 227, 135)
        UITabBar.appearance().tintColor = UIColor.rgb(163, 232, 178)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundImage = image
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().tintColor = UIColor.rgb(163, 232, 178)
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
    }
}

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        let m: CGFloat = 255.0
        return UIColor(red: r/m, green: g/m, blue: b/m, alpha: 1)
    }
}

extension UILabel {
    var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
    
    var defaultTextColor: UIColor? {
        get { return self.textColor }
        set { self.textColor = newValue }
    }
}

class StyleManager {
    
}

struct StyleManagerMiddleware<S, T: Store<S>> {
    static func create() -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    switch action {
                    case AppAction.launch:
                        store.dispatch(StyleAction.set(GreenStyle()))
                        next(action)
                    case StyleAction.list(.loading):
                        next(action)
                        store.dispatch(StyleAction.list(.success([BlueStyle(), GreenStyle()])))
                    case StyleAction.set(let style):
                        style.apply()
                        style.refresh()
                        next(action)
                    default:
                        next(action)
                        break
                    }
                }
            }
        }
    }
}

