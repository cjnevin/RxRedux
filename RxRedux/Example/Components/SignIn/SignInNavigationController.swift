import UIKit
import RxSwift

extension SignInViewController {
    static func make() -> SignInViewController {
        return SignInViewController(nibName: nil, bundle: nil)
    }
}

class SignInNavigationController: UINavigationController {
    private let disposable = SingleAssignmentDisposable()
    
    override init(rootViewController: UIViewController = SignInViewController.make()) {
        super.init(rootViewController: rootViewController)
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "sign-in-empty"), selectedImage: #imageLiteral(resourceName: "sign-in-filled"))
        tabBarItem.accessibilityLabel = "Sign In Tab"
        disposable.setDisposable(tabBarItem.setTitle("sign.in.tab.title"))
        _ = rootViewController.view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Must be overridden or we get:
    // Fatal error: Use of unimplemented initializer 'init(nibName:bundle:)' for class
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
