
import UIKit

extension UIColor {
    static let ypBlue = UIColor(named: "ypBlue")
    static let ypRed = UIColor(named: "ypRed")
    static let ypGray = UIColor(named: "ypGray")
    static let ypBlack = UIColor(named: "ypBlack")
    static let ypBackground = UIColor(named: "ypBackground")
    static let ypLightGray = UIColor(named: "ypLightGray")
    
    static let toggleBlackWhiteColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
