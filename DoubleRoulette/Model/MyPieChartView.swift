//
//  MyPieChartView.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/03.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

struct Segment {
    var color: UIColor
    var value: CGFloat
}

class MyPieChartView: UIView {
    var radius = CGFloat(1)
    
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        let viewCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let valueCount = segments.reduce(0) {$0 + $1.value}
        
        var startAngle = -CGFloat(Double.pi * 0.5)
        
        ctx?.setFillColor(UIColor.gray.cgColor)
        ctx?.move(to: CGPoint(x: viewCenter.x, y: viewCenter.y))
        ctx?.addArc(center: CGPoint(x:viewCenter.x, y: viewCenter.y), radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
        ctx?.fillPath()
        
        for segment in segments {
            ctx?.setFillColor(segment.color.cgColor)
            let endAngle = startAngle+CGFloat(Double.pi * 2) * (segment.value / valueCount)
            ctx?.move(to: CGPoint(x:viewCenter.x, y: viewCenter.y))
            ctx?.addArc(center: CGPoint(x:viewCenter.x, y: viewCenter.y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            ctx?.fillPath()
            startAngle = endAngle
        }
    }
}
