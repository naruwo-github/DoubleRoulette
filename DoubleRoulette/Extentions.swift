//
//  Extentions.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

extension UIColor {
    
    // これは現状使っていない
//    convenience init(hex: String, alpha: CGFloat = 1) {
//        let v = Int("000000" + hex, radix: 16) ?? 0
//        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
//        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
//        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
//        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
//    }
    
    class func hexToRGB(hex color: String) -> [Int] {
        var rgb: [Int] = []
        let scanner = Scanner(string: color as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = (color & 0xFF0000) >> 16
            let g = (color & 0x00FF00) >> 8
            let b = (color & 0x0000FF)
            rgb.append(Int(r))
            rgb.append(Int(g))
            rgb.append(Int(b))
        }
        return rgb
    }
    
    // 使われていない
//    class func hexToUIColor(color: String, alpha: CGFloat = 1) -> UIColor {
//        let code = color
//        let scanner = Scanner(string: code as String)
//        var color: UInt32 = 0
//        if scanner.scanHexInt32(&color) {
//            let r = (color & 0xFF0000) >> 16
//            let g = (color & 0x00FF00) >> 8
//            let b = (color & 0x0000FF)
//            return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: alpha)
//        } else {
//            print("invalid hex string")
//            return UIColor.clear
//        }
//    }
    
    class func rgbToHex(red r: Int, green g: Int, blue b: Int) -> String {
        return String(NSString(format: "%02X%02X%02X", r, g, b))
    }
    
    class func rgbToUIColor(red r: Int, green g: Int, blue b: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
    class func convertToRGB(_ color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = color.cgColor.components!
        return (red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

extension String {
    func attributedString(
        _ color: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: 13.0),
        lineSpace: CGFloat = 8,
        align: NSTextAlignment = .left,
        kern: CGFloat = 0) -> NSAttributedString {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = lineSpace
            paragraph.alignment = align
            return NSAttributedString(string: self, attributes: [
                NSAttributedString.Key.paragraphStyle: paragraph,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.kern: kern
                ])
    }
}
