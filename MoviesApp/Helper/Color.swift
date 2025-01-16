//
//  Color.swift
//  MoviesApp
//
//  Created by Павел on 12.01.2025.
//
import UIKit

class Color {
    static let backgroundGray = UIColor(hex: "242A32")
    static let white: UIColor = .white
    static let stackColor = UIColor(hex: "92929D")
    static let orangeRating = UIColor(hex: "FF8700")
    static let lightGray = UIColor(hex: "67686D")
    static let darkerThanLightButLighterThanDark = UIColor(hex: "3A3F47")
    static let blue = UIColor(hex: "0296E5")
}
extension UIColor {

    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        
        guard length == 6 || length == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else { return nil }
        
        if length == 6 {
            let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            let r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let a = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        }
    }
}
