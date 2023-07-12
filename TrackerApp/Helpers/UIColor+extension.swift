
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
    
    static func colorFromHex(hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        guard hex.count == 6 else { return UIColor.clear }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

}
