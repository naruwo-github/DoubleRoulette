//
//  Extentions.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

extension UIColor {
    // イニシャライザを追加
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    // ルーレットのラベル(文字)の色
    class var rouletteLabel: UIColor {
        return UIColor(named: "rouletteLabel") ?? UIColor.black
    }
    
    // ナビゲーションアイテムの色
    class var navigationItem: UIColor {
        return UIColor(named: "navigationItemColor") ?? UIColor.gray
    }
    
    //＊＊＊＊色変換＊＊＊＊
    // HexをRGBに
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
    
    // HexをUIColorに
    class func hexToRgb(color: String, alpha: CGFloat = 1) -> UIColor {
        let code = color
        let scanner = Scanner(string: code as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = (color & 0xFF0000) >> 16
            let g = (color & 0x00FF00) >> 8
            let b = (color & 0x0000FF)
            return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: alpha)
        } else {
            print("invalid hex string")
            return UIColor.clear
        }
    }
    
    // RGBをHexに
    class func rgbToHex(red r: Int, green g: Int, blue b: Int) -> String {
        return String(NSString(format: "%02X%02X%02X", r, g, b))
    }
    
    // rgbをUIColorに
    class func rgbToColor(red r: Int, green g: Int, blue b: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    // UIColorをRGBに変換する
    class func convertToRGB(_ color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = color.cgColor.components! // UIColorをCGColorに変換し、RGBとAlphaがそれぞれCGFloatで配列として取得できる
        return (red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

extension UIView {
    // 広告を隠したスクリーンショットを撮る関数（WindowFrameが画面領域、adFrameが広告領域）
    // TODO: 回転後をUIImageとして書き出せない問題が残っている
    func getScreenShot(windowFrame: CGRect, adFrame: CGRect?, backgroundColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        if let frame = adFrame {
            context.setFillColor(backgroundColor.cgColor)
            context.fill(frame)
        }
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
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
