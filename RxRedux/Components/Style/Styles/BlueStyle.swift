import UIKit

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
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.rgb(53, 107, 141)
        UITabBar.appearance().tintColor = UIColor.rgb(135, 185, 218)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundImage = image
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.rgb(135, 185, 218)
        UINavigationBar.appearance().barTintColor = UIColor.rgb(5, 32, 60)
        
        UISearchBar.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        LoadingView.appearance().backgroundColor = UIColor.rgb(5, 32, 60)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.rgb(135, 185, 218)]
    }
}
