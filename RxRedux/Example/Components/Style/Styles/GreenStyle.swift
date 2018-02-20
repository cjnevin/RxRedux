import UIKit

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
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.rgb(163, 232, 178)
        UINavigationBar.appearance().barTintColor = UIColor.rgb(56, 113, 66)
        
        UISearchBar.appearance().backgroundColor = UIColor.rgb(56, 113, 66)
        
        LoadingView.appearance().backgroundColor = UIColor.rgb(56, 113, 66)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.rgb(163, 232, 178)]
    }
}
