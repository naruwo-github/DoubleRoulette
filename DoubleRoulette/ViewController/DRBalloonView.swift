//
//  DRBalloonView.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

enum TriangleDirection {
    case Top
    case Left
    case Bottom
    case Right
}

// MARK: - <吹き出しの三角形を管理するクラス>
class DRBalloonView: UIView {
    
    private var triangleDirection = TriangleDirection.Left
    
    @IBInspectable var triangleDirectionOption: Int = 0 {
        didSet {
            switch triangleDirectionOption {
            case 0:
                triangleDirection = .Top
                
            case 1:
                triangleDirection = .Left
                
            case 2:
                triangleDirection = .Bottom
                
            case 3:
                triangleDirection = .Right
                
            default:
                assertionFailure("Not Exists")
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var triangleSideLength: CGFloat = 20
    
    @IBInspectable var triangleHeight: CGFloat = 20
    
    @IBInspectable var fillColor: UIColor = UIColor.black
    
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
    
    private func setButtonShadow() {
        if self.enableShadow {
            self.clipsToBounds = false
            self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            self.layer.shadowColor = self.shadowColor.cgColor
            self.layer.shadowRadius = 4.0
            self.layer.shadowOpacity = self.shadowOpacity
        } else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowColor = nil
            self.layer.shadowOpacity = 0
        }
    }
    
    override func draw(_ rect: CGRect) {
        // StroyBoardで制約を入れていればその高さと幅のRectが入る
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.fillColor.cgColor)
        switch self.triangleDirection {
        case .Top:
            self.contextTopDirectionBalloonPath(context: context!, rect: rect)
            
        case .Left:
            self.contextLeftDirectionBalloonPath(context: context!, rect: rect)
            
        case .Bottom:
            self.contextBottomDirectionBalloonPath(context: context!, rect: rect)
            
        case .Right:
            self.contextRightDirectionBalloonPath(context: context!, rect: rect)
        }
    }
    
    private func contextTopDirectionBalloonPath(context: CGContext, rect: CGRect) {
        let triangleTopCorner = (x: triangleSideLength / 2, y: CGFloat.init())
        let triangleRightBottomCorner = (x: triangleSideLength, y: triangleHeight)
        let triangleLeftBottomCorner = (x: CGFloat.init(), y: triangleHeight)
        
        context.move(to: CGPoint(x: triangleTopCorner.x, y: triangleTopCorner.y))
        context.addLine(to: CGPoint(x: triangleRightBottomCorner.x, y: triangleRightBottomCorner.y))
        context.addLine(to: CGPoint(x: triangleLeftBottomCorner.x, y: triangleLeftBottomCorner.y))
        context.fillPath()
    }
    
    private func contextLeftDirectionBalloonPath(context: CGContext, rect: CGRect) {
        let triangleRightTopCorner = (x: triangleSideLength, y: triangleHeight)
        let triangleRightBottomCorner = (x: triangleSideLength, y: CGFloat.init())
        let triangleLeftCorner = (x: CGFloat.init(), y: triangleHeight / 2)
        
        context.move(to: CGPoint(x: triangleLeftCorner.x, y: triangleLeftCorner.y))
        context.addLine(to: CGPoint(x: triangleRightTopCorner.x, y: triangleRightTopCorner.y))
        context.addLine(to: CGPoint(x: triangleRightBottomCorner.x, y: triangleRightBottomCorner.y))
        context.fillPath()
    }
    
    private func contextBottomDirectionBalloonPath(context: CGContext, rect: CGRect) {
        let triangleRightTopCorner = (x: triangleSideLength, y: CGFloat.init())
        let triangleLeftTopCorner = (x: CGFloat.init(), y: CGFloat.init())
        let triangleBottomCorner = (x: triangleSideLength / 2, y: triangleHeight)
        
        context.move(to: CGPoint(x: triangleLeftTopCorner.x, y: triangleLeftTopCorner.y))
        context.addLine(to: CGPoint(x: triangleRightTopCorner.x, y: triangleRightTopCorner.y))
        context.addLine(to: CGPoint(x: triangleBottomCorner.x, y: triangleBottomCorner.y))
        context.fillPath()
    }
    
    private func contextRightDirectionBalloonPath(context: CGContext, rect: CGRect) {
        let triangleRightCorner = (x: triangleSideLength, y: triangleHeight / 2)
        let triangleLeftTopCorner = (x: CGFloat.init(), y: triangleHeight)
        let triangleLeftBottomCorner = (x: CGFloat.init(), y: CGFloat.init())
        
        context.move(to: CGPoint(x: triangleRightCorner.x, y: triangleRightCorner.y))
        context.addLine(to: CGPoint(x: triangleLeftTopCorner.x, y: triangleLeftTopCorner.y))
        context.addLine(to: CGPoint(x: triangleLeftBottomCorner.x, y: triangleLeftBottomCorner.y))
        context.fillPath()
    }
    
}
