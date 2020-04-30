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
import Accounts
import RealmSwift

class ViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!
    @IBOutlet weak var bottomAdView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var elementNumLabel: UILabel!
    @IBOutlet weak var outerChartView: UIView!
    @IBOutlet weak var innerChartView: UIView!
    var audioPlayer: AVAudioPlayer!
    var rouletteCells: Results<RouletteObject>!
    
    var currentPositionOuter = 0                //rotation angle of outer
    var currentPositionInner = 0                //rotation angle of inner
    
    let pieChartViewOuter = MyPieChartView()
    let pieChartViewInner = MyPieChartView()
    
    let labelFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var outerName: [String] = []
        var outerColor: [UIColor] = []
        var innerName: [String] = []
        var innerColor: [UIColor] = []
        for i in 0..<rouletteCells.count {
            let cell = rouletteCells[i]
            let hex = cell.color
            let rgb = UIColor.hexToRGB(hex: hex)
            let cellColor = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            if cell.type == 0 {
                outerName.insert(cell.item, at: 0)
                outerColor.insert(cellColor, at: 0)
            }else {
                innerName.insert(cell.item, at: 0)
                innerColor.insert(cellColor, at: 0)
            }
        }
        itemsLabel.text = "Items: " + String(rouletteCells.count)
        elementNumLabel.text = "Outer: " + String(outerName.count) + ", Inner: " + String(innerName.count)
        
        setOuterRoulette(outerName: outerName, outerColor: outerColor)
        setInnerRoulette(innerName: innerName, innerColor: innerColor)
        
        //Outer Label
        let angleOfOuterPiece = CGFloat.pi * 2.0 / CGFloat(outerName.count)
        let distFromOuterCenter = self.view.frame.width * 3 / 8
        let startPoint = self.view.center
        let firstOuterLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromOuterCenter)
        for i in 0..<outerName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = outerName[i]
            sampleLabel.adjustsFontSizeToFitWidth = true
            sampleLabel.textAlignment = .center
            sampleLabel.backgroundColor = UIColor.clear
            sampleLabel.textColor = UIColor.rouletteLabel
            sampleLabel.numberOfLines = 0
            let x = firstOuterLabelPoint.x - startPoint.x
            let y = firstOuterLabelPoint.y - startPoint.y
            let nextx = cos(-(angleOfOuterPiece*I + angleOfOuterPiece/2))*x - sin(-(angleOfOuterPiece*I + angleOfOuterPiece/2))*y + startPoint.x
            let nexty = sin(-(angleOfOuterPiece*I + angleOfOuterPiece/2))*x + cos(-(angleOfOuterPiece*I + angleOfOuterPiece/2))*y + startPoint.y
            sampleLabel.center = CGPoint(x: nextx, y: nexty)
            outerChartView.addSubview(sampleLabel)
        }
        
        //Inner Label
        let angleOfInnerPiece = CGFloat.pi * 2.0 / CGFloat(innerName.count)
        let distFromInnerCenter = self.view.frame.width / 8
        let firstInnerLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromInnerCenter)
        for i in 0..<innerName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = innerName[i]
            sampleLabel.adjustsFontSizeToFitWidth = true
            sampleLabel.textAlignment = .center
            sampleLabel.backgroundColor = UIColor.clear
            sampleLabel.textColor = UIColor.rouletteLabel
            sampleLabel.numberOfLines = 0
            let x = firstInnerLabelPoint.x - startPoint.x
            let y = firstInnerLabelPoint.y - startPoint.y
            let nextx = cos(-(angleOfInnerPiece*I + angleOfInnerPiece/2))*x - sin(-(angleOfInnerPiece*I + angleOfInnerPiece/2))*y + startPoint.x
            let nexty = sin(-(angleOfInnerPiece*I + angleOfInnerPiece/2))*x + cos(-(angleOfInnerPiece*I + angleOfInnerPiece/2))*y + startPoint.y
            sampleLabel.center = CGPoint(x: nextx, y: nexty)
            innerChartView.addSubview(sampleLabel)
        }
        
        drawArrow()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.bottomAdView.addSubview(bannerView)
        bannerView.center.x = self.view.center.x
        bannerView.adUnitID = "ca-app-pub-6492692627915720/3283423713"
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
        arrowView.isUserInteractionEnabled = false
        arrowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let topImageView = UIImageView()
        topImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: self.view.frame.height/14)
        let topArrow = UIImage(named: "arrow1")
        topImageView.image = topArrow
        topImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - self.view.frame.width/2)
        
        let bottomImageView = UIImageView()
        bottomImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/9, height: self.view.frame.height/4.5)
        let bottomArrow = UIImage(named: "arrow2")
        bottomImageView.image = bottomArrow
        bottomImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + self.view.frame.width*3/8)
        
        arrowView.addSubview(topImageView)
        arrowView.addSubview(bottomImageView)
        
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
    
    //share button
    @IBAction func shareButton(_ sender: Any) {
        let shareText = "Double Roulette ScreenShot!"
        let shareImage = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: self.bannerView.frame, backgroundColor: self.view.backgroundColor!)
        let activityItems = [shareText, shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
        }
    }
}
