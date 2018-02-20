import UIKit

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        let m: CGFloat = 255.0
        return UIColor(red: r/m, green: g/m, blue: b/m, alpha: 1)
    }
}
