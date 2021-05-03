//
//  Extensions.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <デフォルトモジュールの拡張>

extension UIColor {
    
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

extension UIView {
    
    func addSubviewWithConstraintAround(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
