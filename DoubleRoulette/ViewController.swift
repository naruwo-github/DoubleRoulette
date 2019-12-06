//
//  ViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//


import UIKit
import AVFoundation
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!              //admob view
    @IBOutlet weak var startButton: UIButton!   //rotation button
    @IBOutlet weak var itemsLabel: UILabel!     //items number
    @IBOutlet weak var outerChartView: UIView!  //outer view
    @IBOutlet weak var innerChartView: UIView!  //inner view
    var audioPlayer: AVAudioPlayer!             //audio player
    
    var itemData = [TableViewCell]()
    var itemName: [String] = []
    var itemColor: [UIColor] = []
    var itemType: [Int] = []
    
    var currentPositionOuter = 0                //rotation angle of outer
    var currentPositionInner = 0                //rotation angle of inner
    
    let pieChartViewOuter = MyPieChartView()
    let pieChartViewInner = MyPieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var outerName: [String] = []
        var outerColor: [UIColor] = []
        var innerName: [String] = []
        var innerColor: [UIColor] = []
        for i in 0..<itemData.count {
            if itemType[i] == 0 {
                outerName.insert(itemName[i], at: 0)
                outerColor.insert(itemColor[i], at: 0)
            }else {
                innerName.insert(itemName[i], at: 0)
                innerColor.insert(itemColor[i], at: 0)
            }
        }
        itemsLabel.text = "Items: " + String(itemData.count)
        
        setOuterRoulette(outerName: outerName, outerColor: outerColor)
        setInnerRoulette(innerName: innerName, innerColor: innerColor)
        
        //roulette element label setting
        let angleOuter = Double.pi * 2.0 / Double(outerName.count)
        let centerOuterX = self.view.frame.width / 2 - 18
        let centerOuterY = self.view.frame.height / 2 - 25
        let originOuterX = centerOuterX
        let originOuterY = centerOuterY - self.view.frame.height / 5
        
        let angleInner = Double.pi * 2.0 / Double(innerName.count)
        let centerInnerX = self.view.frame.width / 2 - 18
        let centerInnerY = self.view.frame.height / 2 - 25
        let originInnerX = centerInnerX
        let originInnerY = centerInnerY - self.view.frame.height / 12
        
        for i in 0..<outerName.count {
            let labelView = UILabel()
            labelView.isOpaque = false
            labelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            labelView.frame.size = CGSize(width: self.view.frame.width/9, height: self.view.frame.height/18)
            labelView.adjustsFontSizeToFitWidth = true
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
            outerChartView.addSubview(labelView)
        }
        
        for i in 0..<innerName.count {
            let labelView = UILabel()
            labelView.isOpaque = false
            labelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            labelView.frame.size = CGSize(width: self.view.frame.width/9, height: self.view.frame.height/18)
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
        
        //矢印描画
        drawArrow()
        
        //広告
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        //本物
        //DRRouletteView
        bannerView.adUnitID = "ca-app-pub-6492692627915720/3283423713"
        //テスト
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func setOuterRoulette(outerName: [String], outerColor: [UIColor]) {
        pieChartViewOuter.radius = min(self.view.frame.size.width, self.view.frame.size.height)/2
        pieChartViewOuter.isOpaque = false
        pieChartViewOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewOuter.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        for i in 0..<outerName.count {
            pieChartViewOuter.segments.insert(Segment(color: outerColor[i], value: CGFloat(Double.pi * 2.0 / Double(outerName.count))), at: 0)
        }
        outerChartView.addSubview(pieChartViewOuter)
    }
    
    func setInnerRoulette(innerName: [String], innerColor: [UIColor]) {
        pieChartViewInner.radius = min(self.view.frame.size.width, self.view.frame.size.height)/4
        pieChartViewInner.isOpaque = false
        pieChartViewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewInner.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        for i in 0..<innerName.count {
            pieChartViewInner.segments.insert(Segment(color: innerColor[i], value: CGFloat(Double.pi * 2.0 / Double(innerName.count))), at: 0)
        }
        innerChartView.addSubview(pieChartViewInner)
    }
    
    func drawArrow() {
        let arrowView = UIView()
        arrowView.isOpaque = false
        arrowView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        arrowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        
        //triangleOuter
        let clockHandOuter = CAShapeLayer()
        clockHandOuter.strokeColor = UIColor.white.cgColor
        clockHandOuter.fillColor = UIColor.black.cgColor
        clockHandOuter.lineWidth = 2.0
        
        let triangleOuter = UIBezierPath()
        triangleOuter.move(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.width / 2 + 50))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2 - 10, y: self.view.frame.height / 2 - self.view.frame.width / 2 * 1.15))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2 + 10, y: self.view.frame.height / 2 - self.view.frame.width / 2 * 1.15))
        triangleOuter.addLine(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.width / 2 + 50))
        
        triangleOuter.fill()
        clockHandOuter.path = triangleOuter.cgPath
        
        arrowView.layer.addSublayer(clockHandOuter)
        
        
        //triangleInner
        let clockHandInner = CAShapeLayer()
        clockHandInner.strokeColor = UIColor.white.cgColor
        clockHandInner.fillColor = UIColor.black.cgColor
        clockHandInner.lineWidth = 2.0
        
        let triangleInner = UIBezierPath()
        triangleInner.move(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.width / 2 - self.view.frame.width / 3))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2 - 10, y: self.view.frame.height / 2 + self.view.frame.width / 2 * 1.15))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2 + 10, y: self.view.frame.height / 2 + self.view.frame.width / 2 * 1.15))
        triangleInner.addLine(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.width / 2 - self.view.frame.width / 3))

        triangleInner.fill()
        clockHandInner.path = triangleInner.cgPath
        arrowView.layer.addSublayer(clockHandInner)
        
        
        //circle
        let circleOuterLayer = CAShapeLayer()
        circleOuterLayer.strokeColor = UIColor.black.cgColor
        circleOuterLayer.fillColor = UIColor.black.cgColor
        circleOuterLayer.lineWidth = 2.0
        let circleOuter = UIBezierPath()
        circleOuter.move(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.width / 2 * 1.15))
        circleOuter.addArc(withCenter: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.width / 2 * 1.15), radius: 10, startAngle: 0, endAngle: 360, clockwise: true)
        circleOuter.fill()
        circleOuterLayer.path = circleOuter.cgPath
        arrowView.layer.addSublayer(circleOuterLayer)
        
        let circleInnerLayer = CAShapeLayer()
        circleInnerLayer.strokeColor = UIColor.black.cgColor
        circleInnerLayer.fillColor = UIColor.black.cgColor
        circleInnerLayer.lineWidth = 2.0
        let circleInner = UIBezierPath()
        circleInner.move(to: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.width / 2 * 1.15))
        circleInner.addArc(withCenter: CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.width / 2 * 1.15), radius: 10, startAngle: 0, endAngle: 360, clockwise: true)
        
        circleInner.fill()
        circleInnerLayer.path = circleInner.cgPath
        arrowView.layer.addSublayer(circleInnerLayer)
        
        //addView
        self.view .bringSubviewToFront(arrowView)
        self.view.addSubview(arrowView)
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
        
        outerChartView.layer.add(animationOuter, forKey: "animationOuter")
        innerChartView.layer.add(animationInner, forKey: "animationInner")
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            //print("no music file")
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
