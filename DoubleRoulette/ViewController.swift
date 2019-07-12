//
//  ViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //rotation button
    @IBOutlet weak var startButton: UIButton!
    //item num
    @IBOutlet weak var itemsLabel: UILabel!
    //chartview outter
    @IBOutlet weak var outterChartView: UIView!
    //chartview inner
    @IBOutlet weak var innerChartView: UIView!
    
    var audioPlayer: AVAudioPlayer!
    
    var itemData = [TableViewCell]()
    var itemName: [String] = []
    var itemColor: [UIColor] = []
    var itemType: [Int] = []
    
    //outer
    var currentPositionOuter = 0
    //inner
    var currentPositionInner = 0
    
    //roulette element layer
    var rouletteLayer = [CAShapeLayer()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemsLabel.text = "Items: " + String(itemData.count)
        //矢印描画
        drawArrow()
    }

    //roulette start
    @IBAction func startButtonTapped(_ sender: Any) {
        playSound(name: "roulette-sound")
        //outer
        let angleOuter: CGFloat = CGFloat(Double.random(in: 100.0 ... 500.0) * Double.pi / 6.0)
        let fromValOuter: CGFloat = angleOuter * CGFloat(currentPositionOuter)
        let toValOuter: CGFloat = angleOuter * CGFloat(currentPositionOuter+1)
        let animationOuter: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        animationOuter.isRemovedOnCompletion = false
        animationOuter.fillMode = CAMediaTimingFillMode.forwards
        animationOuter.fromValue = fromValOuter
        animationOuter.toValue = toValOuter
        animationOuter.duration = 4.0
        
        //inner
        let angleInner: CGFloat = CGFloat(Double.random(in: 100.0 ... 500.0) * Double.pi / 6.0)
        let fromValInner: CGFloat = angleInner * CGFloat(currentPositionInner)
        let toValInner: CGFloat = angleInner * CGFloat(currentPositionInner+1)
        let animationInner: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        animationInner.isRemovedOnCompletion = false
        animationInner.fillMode = CAMediaTimingFillMode.forwards
        animationInner.fromValue = fromValInner
        animationInner.toValue = toValInner
        animationInner.duration = 5.0
        
        outterChartView.layer.add(animationOuter, forKey: "animationOuter")
        innerChartView.layer.add(animationInner, forKey: "animationInner")
    }
     
    //矢印召喚
    func drawArrow() {
        let arrowView = UIView()
        arrowView.isOpaque = false
        arrowView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        arrowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 200)
        
        //triangleOuter
        let clockHandOuter = CAShapeLayer()
        clockHandOuter.strokeColor = UIColor.white.cgColor
        clockHandOuter.fillColor = UIColor.black.cgColor
        clockHandOuter.lineWidth = 1.0
        
        let triangleOuter = UIBezierPath()
        triangleOuter.move(to: CGPoint.init(x: self.view.frame.width / 2, y: 300))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2 - 10, y: 100))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2 + 10, y: 100))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2, y: 300))
        
        triangleOuter.fill()
        clockHandOuter.path = triangleOuter.cgPath
        
        arrowView.layer.addSublayer(clockHandOuter)
        
        
        //triangleInner
        let clockHandInner = CAShapeLayer()
        clockHandInner.strokeColor = UIColor.white.cgColor
        clockHandInner.fillColor = UIColor.black.cgColor
        clockHandInner.lineWidth = 1.0
        
        let triangleInner = UIBezierPath()
        triangleInner.move(to: CGPoint.init(x: self.view.frame.width / 2, y: 300 + 150))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2 - 10, y: 300 + 150 + 100))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2 + 10, y: 300 + 150 + 100))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2, y: 300 + 150))

        triangleInner.fill()
        clockHandInner.path = triangleInner.cgPath
        //self.view.layer.addSublayer(clockHandInner)
        arrowView.layer.addSublayer(clockHandInner)
        
        
        //circle
        let circleOuterLayer = CAShapeLayer()
        circleOuterLayer.strokeColor = UIColor.black.cgColor
        circleOuterLayer.fillColor = UIColor.black.cgColor
        circleOuterLayer.lineWidth = 2.0
        let circleOuter = UIBezierPath()
        circleOuter.move(to: CGPoint.init(x: self.view.frame.width / 2, y: 100))
        circleOuter.addArc(withCenter: CGPoint.init(x: self.view.frame.width / 2, y: 100), radius: 10, startAngle: 0, endAngle: 360, clockwise: true)
        circleOuter.fill()
        circleOuterLayer.path = circleOuter.cgPath
        arrowView.layer.addSublayer(circleOuterLayer)
        
        let circleInnerLayer = CAShapeLayer()
        circleInnerLayer.strokeColor = UIColor.black.cgColor
        circleInnerLayer.fillColor = UIColor.black.cgColor
        circleInnerLayer.lineWidth = 2.0
        let circleInner = UIBezierPath()
        circleInner.move(to: CGPoint.init(x: self.view.frame.width / 2, y: 300 + 150 + 100))
        circleInner.addArc(withCenter: CGPoint.init(x: self.view.frame.width / 2, y: 300 + 150 + 100), radius: 10, startAngle: 0, endAngle: 360, clockwise: true)
        
        circleInner.fill()
        circleInnerLayer.path = circleInner.cgPath
        arrowView.layer.addSublayer(circleInnerLayer)
        
        //addView
        self.view .bringSubviewToFront(arrowView)
        self.view.addSubview(arrowView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //outer
        var outerName: [String] = []
        var outerColor: [UIColor] = []
        //inner
        var innerName: [String] = []
        var innerColor: [UIColor] = []
        
        //devide into 2 categories
        for i in 0..<itemData.count {
            if itemType[i] == 0 {
                //outer
                outerName.insert(itemName[i], at: 0)
                outerColor.insert(itemColor[i], at: 0)
            }else {
                //inner
                innerName.insert(itemName[i], at: 0)
                innerColor.insert(itemColor[i], at: 0)
            }
        }
        
        //円を描く
        let outerCircleLayer = CAShapeLayer()
        let innerCircleLayer = CAShapeLayer()
        outerCircleLayer.strokeColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.1).cgColor
        outerCircleLayer.fillColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.1).cgColor
        outerCircleLayer.lineWidth = 2.0
        innerCircleLayer.strokeColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.1).cgColor
        innerCircleLayer.fillColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.1).cgColor
        innerCircleLayer.lineWidth = 2.0
        
        let outerCircle = UIBezierPath()
        outerCircle.move(to: CGPoint.init(x: outterChartView.frame.width / 2, y: outterChartView.frame.height / 2))
        outerCircle.addArc(withCenter: CGPoint.init(x: outterChartView.frame.width / 2, y: outterChartView.frame.height / 2), radius: outterChartView.frame.width / 2 + 2, startAngle: 0, endAngle: 360, clockwise: true)
        
        let innerCircle = UIBezierPath()
        innerCircle.move(to: CGPoint.init(x: innerChartView.frame.width / 2, y: innerChartView.frame.height / 2))
        innerCircle.addArc(withCenter: CGPoint.init(x: innerChartView.frame.width / 2, y: innerChartView.frame.height / 2), radius: innerChartView.frame.width / 2 + 2, startAngle: 0, endAngle: 360, clockwise: true)
        
        outerCircle.stroke()
        outerCircleLayer.path = outerCircle.cgPath
        outterChartView.layer.addSublayer(outerCircleLayer)
        
        innerCircle.stroke()
        innerCircleLayer.path = innerCircle.cgPath
        innerChartView.layer.addSublayer(innerCircleLayer)
        
        
        //outer view
        let pieChartViewOuter = MyPieChartView()
        pieChartViewOuter.isOpaque = false
        pieChartViewOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewOuter.frame = CGRect(x: 0, y: 0, width: outterChartView.frame.size.width, height: outterChartView.frame.size.height)
        
        //inner view
        let pieChartViewInner = MyPieChartView()
        pieChartViewInner.isOpaque = false
        pieChartViewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewInner.frame = CGRect(x: 0, y: 0, width: innerChartView.frame.size.width, height: innerChartView.frame.size.height)
        
        //add to each view
        for i in 0..<outerName.count {
            pieChartViewOuter.segments.insert(Segment(color: outerColor[i], value: CGFloat(Double.pi * 2.0 / Double(outerName.count)), label: outerName[i]), at: 0)
        }
        for i in 0..<innerName.count {
            pieChartViewInner.segments.insert(Segment(color: innerColor[i], value: CGFloat(Double.pi * 2.0 / Double(innerName.count)), label: innerName[i]), at: 0)
        }
        
        outterChartView.addSubview(pieChartViewOuter)
        innerChartView.addSubview(pieChartViewInner)
        
        outterChartView.layer.cornerRadius = outterChartView.frame.width / 2.0
        innerChartView.layer.cornerRadius = innerChartView.frame.width / 2.0
        
        
        //roulette element label setting
        //outer move
        let angleOuter = Double.pi * 2.0 / Double(outerName.count)
        let centerOuterX = outterChartView.frame.width / 2 - 18
        let centerOuterY = outterChartView.frame.height / 2 - 25
        let originOuterX = centerOuterX
        let originOuterY = centerOuterY - outterChartView.frame.height / 3
        //inner move
        let angleInner = Double.pi * 2.0 / Double(innerName.count)
        let centerInnerX = innerChartView.frame.width / 2 - 18
        let centerInnerY = innerChartView.frame.height / 2 - 25
        let originInnerX = centerInnerX
        let originInnerY = centerInnerY - innerChartView.frame.height / 3
        
        for i in 0..<outerName.count {
            let labelView = UILabel()
            labelView.isOpaque = false
            labelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            labelView.frame.size = CGSize(width: 100, height: 50)
            labelView.text = outerName[i]
            
            let coox = originOuterX - centerOuterX
            let cooy = originOuterY - centerOuterY
            let moveAngle1 = angleOuter / 2.0
            let sinAngle1 = CGFloat(sin(-moveAngle1))
            let cosAngle1 = CGFloat(cos(-moveAngle1))
            var coox1 = cosAngle1 * coox - sinAngle1 * cooy
            var cooy1 = sinAngle1 * coox + cosAngle1 * cooy
            coox1 += centerOuterX
            cooy1 += centerOuterY
            
            let moveAngle2 = Double(i) * angleOuter
            let sinAngle2 = CGFloat(sin(-moveAngle2))
            let cosAngle2 = CGFloat(cos(-moveAngle2))
            var positionX = cosAngle2 * (coox1 - centerOuterX) - sinAngle2 * (cooy1 - centerOuterY)
            var positionY = sinAngle2 * (coox1 - centerOuterX) + cosAngle2 * (cooy1 - centerOuterY)
            positionX += centerOuterX
            positionY += centerOuterY
            
            labelView.frame.origin = CGPoint(x: positionX, y: positionY)
            
            //add!!
            outterChartView.addSubview(labelView)
        }
        
        for i in 0..<innerName.count {
            let labelView = UILabel()
            labelView.isOpaque = false
            labelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            labelView.frame.size = CGSize(width: 100, height: 50)
            labelView.text = innerName[i]
            
            let coox = originInnerX - centerInnerX
            let cooy = originInnerY - centerInnerY
            let moveAngle1 = angleInner / 2.0
            let sinAngle1 = CGFloat(sin(-moveAngle1))
            let cosAngle1 = CGFloat(cos(-moveAngle1))
            var coox1 = cosAngle1 * coox - sinAngle1 * cooy
            var cooy1 = sinAngle1 * coox + cosAngle1 * cooy
            coox1 += centerInnerX
            cooy1 += centerInnerY
            
            let moveAngle2 = Double(i) * angleInner
            let sinAngle2 = CGFloat(sin(-moveAngle2))
            let cosAngle2 = CGFloat(cos(-moveAngle2))
            var positionX = cosAngle2 * (coox1 - centerInnerX) - sinAngle2 * (cooy1 - centerInnerY)
            var positionY = sinAngle2 * (coox1 - centerInnerX) + cosAngle2 * (cooy1 - centerInnerY)
            positionX += centerInnerX
            positionY += centerInnerY
            
            labelView.frame.origin = CGPoint(x: positionX, y: positionY)
            
            //add!!
            innerChartView.addSubview(labelView)
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("no music file")
            return
        }
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}
