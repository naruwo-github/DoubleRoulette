//
//  DRCustomUIView.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

@IBDesignable
// MARK: - <カスタムしたUIViewのクラス>
class DRCustomUIView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var enableShadow: Bool = false {
        didSet {
            setButtonShadow()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setButtonShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.2 {
        didSet {
            setButtonShadow()
        }
    
    }
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            setButtonShadow()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2.0, height: 2.0) {
        didSet {
            setButtonShadow()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
//    // ボタンのようにタップ時に反応させる
//    @IBInspectable var isButtonMode: Bool = false
    
    fileprivate func setButtonShadow() {
        if self.enableShadow {
            self.clipsToBounds = false
            self.layer.shadowOffset = self.shadowOffset
            self.layer.shadowColor = self.shadowColor.cgColor
            self.layer.shadowRadius = self.shadowRadius
            self.layer.shadowOpacity = self.shadowOpacity
        } else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowColor = nil
            self.layer.shadowOpacity = 0
        }
    }
    
}
