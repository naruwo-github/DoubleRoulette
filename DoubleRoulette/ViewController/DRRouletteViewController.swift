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

class DRRouletteViewController: UIViewController, GADBannerViewDelegate {
    private let AD_UNIT_ID: String = "ca-app-pub-6492692627915720/3283423713"
    private var bannerView: GADBannerView!
    private var popupWindow: UIWindow!
    
    @IBOutlet private weak var bottomAdView: UIView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var itemsLabel: UILabel!
    @IBOutlet private weak var elementNumLabel: UILabel!
    @IBOutlet private weak var outerChartView: UIView!
    @IBOutlet private weak var innerChartView: UIView!
    
    private let labelFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
    private let pieChartViewOuter = MyPieChartView()
    private let pieChartViewInner = MyPieChartView()
    
    fileprivate var audioPlayer: AVAudioPlayer!
    var rouletteCells: Results<RouletteObject>!
    
    private var currentPositionOuter = 0
    private var currentPositionInner = 0
    private var outerName: [String] = []
    private var outerColor: [UIColor] = []
    private var innerName: [String] = []
    private var innerColor: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.setupElementLabels()
        self.setupOuterRoulette(outerName: self.outerName, outerColor: self.outerColor)
        self.setupInnerRoulette(innerName: self.innerName, innerColor: self.innerColor)
        self.setupRouletteCellsLabel()
        self.drawArrow()
        self.setupAdvertisementView()
        self.setupResultWindow()
    }
    
    private func initData() {
        for i in 0..<self.rouletteCells.count {
            let cell = self.rouletteCells[i]
            let hex = cell.color
            let rgb = UIColor.hexToRGB(hex: hex)
            let cellColor = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            if cell.type == 0 {
                self.outerName.insert(cell.item, at: 0)
                self.outerColor.insert(cellColor, at: 0)
            }else {
                self.innerName.insert(cell.item, at: 0)
                self.innerColor.insert(cellColor, at: 0)
            }
        }
    }
    
    private func setupOuterRoulette(outerName: [String], outerColor: [UIColor]) {
        pieChartViewOuter.radius = min(self.view.frame.size.width, self.view.frame.size.height)/2
        pieChartViewOuter.isOpaque = false
        pieChartViewOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewOuter.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        for i in 0..<outerName.count {
            pieChartViewOuter.segments.insert(Segment(color: outerColor[i], value: CGFloat(Double.pi * 2.0 / Double(outerName.count))), at: 0)
        }
        outerChartView.addSubview(pieChartViewOuter)
    }
    
    private func setupInnerRoulette(innerName: [String], innerColor: [UIColor]) {
        pieChartViewInner.radius = min(self.view.frame.size.width, self.view.frame.size.height)/4
        pieChartViewInner.isOpaque = false
        pieChartViewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        pieChartViewInner.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        for i in 0..<innerName.count {
            pieChartViewInner.segments.insert(Segment(color: innerColor[i], value: CGFloat(Double.pi * 2.0 / Double(innerName.count))), at: 0)
        }
        innerChartView.addSubview(pieChartViewInner)
    }
    
    private func setupRouletteCellsLabel() {
        let angleOfOuterPiece = CGFloat.pi * 2.0 / CGFloat(self.outerName.count)
        let distFromOuterCenter = self.view.frame.width * 3 / 8
        let startPoint = self.view.center
        let firstOuterLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromOuterCenter)
        for i in 0..<self.outerName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = self.outerName[i]
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
            self.outerChartView.addSubview(sampleLabel)
        }
        
        let angleOfInnerPiece = CGFloat.pi * 2.0 / CGFloat(self.innerName.count)
        let distFromInnerCenter = self.view.frame.width / 8
        let firstInnerLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromInnerCenter)
        for i in 0..<self.innerName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = self.innerName[i]
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
            self.innerChartView.addSubview(sampleLabel)
        }
    }
    
    private func drawArrow() {
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
    
    private func setupElementLabels() {
        self.itemsLabel.text = "Items: " + self.rouletteCells.count.description
        self.elementNumLabel.text = "Outer: " + self.outerName.count.description + ", Inner: " + self.innerName.count.description
    }
    
    private func setupAdvertisementView() {
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.bottomAdView.addSubview(self.bannerView)
        self.bannerView.center.x = self.view.center.x
        self.bannerView.adUnitID = self.AD_UNIT_ID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    private func showResultWindow() {
        // NOTE: イベント入力を無効
        UIApplication.shared.beginIgnoringInteractionEvents()
        // NOTE: ポップアップウィンドゥをキーウィンドゥに設定
        self.popupWindow.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            UIView.animate(withDuration: 1.0) {
                self.popupWindow.alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 1.0) {
                    self.popupWindow.alpha = 0
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
            // NOTE: 元のウィンドゥをキーウィンドゥに設定
            self.view.window?.makeKeyAndVisible()
            // NOTE: イベント入力を有効
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func setupResultWindow() {
        self.popupWindow = UIWindow.init(frame: self.view.frame)
        self.popupWindow.alpha = 0
        if let vc = UIStoryboard(name: "Popup", bundle: nil).instantiateInitialViewController() as? DRResultViewController {
            self.popupWindow.rootViewController = vc
        }
    }

    //roulette start
    @IBAction private func startButtonTapped(_ sender: Any) {
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
        
        // TODO: ここに当たったラベルを求めて、引数に渡す
        
        self.showResultWindow()
    }
    
    //share button
    @IBAction private func shareButton(_ sender: Any) {
        let shareText = "Double Roulette ScreenShot!"
        let shareImage = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: self.bannerView.frame, backgroundColor: self.view.backgroundColor!)
        let activityItems = [shareText, shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension DRRouletteViewController: AVAudioPlayerDelegate {
    fileprivate func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            return
        }
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        } catch {
        }
    }
}
