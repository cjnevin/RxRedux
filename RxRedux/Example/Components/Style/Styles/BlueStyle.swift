import UIKit

class BlueStyle: Style {
    init() {
        super.init(name: "Blue")
    }
    
    override func apply() {
        applyCommonStyling()
        
        UIButton.appearance().tintColor = UIColor.rgb(11, 42, 62)
        UIButton.appearance().setTitleColor(UIColor.rgb(174, 219, 245), for: .normal)
        UIButton.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        UITableView.appearance().separatorColor = UIColor.rgb(174, 219, 245)
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
        background.backgroundColor = UIColor.rgb(5, 32, 60)
        let renderer = UIGraphicsImageRenderer(size: background.bounds.size)
        let image = renderer.image { ctx in
            background.drawHierarchy(in: background.bounds, afterScreenUpdates: true)
        }
        
        UIApplication.shared.keyWindow?.tintColor = UIColor.rgb(53, 107, 141)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.rgb(53, 107, 141)
        UITabBar.appearance().tintColor = UIColor.rgb(135, 185, 218)
        UITabBar.appearance().backgroundImage = image
        
        UINavigationBar.appearance().tintColor = UIColor.rgb(135, 185, 218)
        UINavigationBar.appearance().barTintColor = UIColor.rgb(5, 32, 60)
        
        UISearchBar.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.rgb(135, 185, 218)
        ]
        
        LoadingView.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        SignInErrorLabel.appearance().textAlignment = .center
        SignInErrorLabel.appearance().textColor = UIColor.rgb(232, 44, 12)
        SignInLocalizableErrorLabel.appearance().textAlignment = .right
    }
}
