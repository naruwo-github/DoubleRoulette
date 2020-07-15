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
    
    private var currentChangedOuterAngle: CGFloat = 0.0
    private var currentChangedInnerAngle: CGFloat = 0.0
    private var outerCellName: [String] = []
    private var outerCellColor: [UIColor] = []
    private var innerCellName: [String] = []
    private var innerCellColor: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.setupResultWindow()
        self.setupElementLabels()
        self.setupOuterRoulette(outerName: self.outerCellName, outerColor: self.outerCellColor)
        self.setupInnerRoulette(innerName: self.innerCellName, innerColor: self.innerCellColor)
        self.setupRouletteCellsLabel()
        self.drawArrow()
        self.setupAdvertisementView()
    }
    
    private func initData() {
        for i in 0..<self.rouletteCells.count {
            let cell = self.rouletteCells[i]
            let hex = cell.color
            let rgb = UIColor.hexToRGB(hex: hex)
            let cellColor = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            if cell.type == 0 {
                self.outerCellName.insert(cell.item, at: 0)
                self.outerCellColor.insert(cellColor, at: 0)
            }else {
                self.innerCellName.insert(cell.item, at: 0)
                self.innerCellColor.insert(cellColor, at: 0)
            }
        }
    }
    
    private func setupResultWindow() {
        self.popupWindow = UIWindow.init(frame: self.view.frame)
        self.popupWindow.windowLevel = UIWindow.Level.normal + 10
        self.popupWindow.alpha = 0
    }
    
    private func setupElementLabels() {
        self.itemsLabel.text = "Items: " + self.rouletteCells.count.description
        self.elementNumLabel.text = "Outer: " + self.outerCellName.count.description + ", Inner: " + self.innerCellName.count.description
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
        let angleOfOuterPiece = CGFloat.pi * 2.0 / CGFloat(self.outerCellName.count)
        let distFromOuterCenter = self.view.frame.width * 3 / 8
        let startPoint = self.view.center
        let firstOuterLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromOuterCenter)
        for i in 0..<self.outerCellName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = self.outerCellName[i]
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
        
        let angleOfInnerPiece = CGFloat.pi * 2.0 / CGFloat(self.innerCellName.count)
        let distFromInnerCenter = self.view.frame.width / 8
        let firstInnerLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromInnerCenter)
        for i in 0..<self.innerCellName.count {
            let I = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = self.innerCellName[i]
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
    
    private func setupResultLabel(outerResult: String?, innerResult: String?) {
        if let vc = R.storyboard.popup.drResultViewController() {
            vc.outer = outerResult
            vc.inner = innerResult
            self.popupWindow.rootViewController = vc
        }
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        if DRUserHelper.isAuthorizedPlaySound {
            self.playSound(name: "roulette-sound")
        }
        
        let cgPi = CGFloat.pi
        let rotationMinimum = cgPi * 2
        
        // NOTE: Outerの回転角度の算出と、アニメーション追加
        let outerRotationAngle = CGFloat.random(in: rotationMinimum ... cgPi * 2 * 10)
        let fromValOuter: CGFloat = self.currentChangedOuterAngle
        let toValOuter: CGFloat = self.currentChangedOuterAngle + outerRotationAngle
        let animationOuter: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        self.currentChangedOuterAngle += outerRotationAngle
        
        animationOuter.isRemovedOnCompletion = false
        animationOuter.fillMode = CAMediaTimingFillMode.forwards
        animationOuter.fromValue = fromValOuter
        animationOuter.toValue = toValOuter
        animationOuter.duration = 4.0
        
        // NOTE: Innerの回転角度の算出と、アニメーション追加
        let innerRotationAngle = CGFloat.random(in: rotationMinimum ... cgPi * 2 * 10)
        let fromValInner: CGFloat = self.currentChangedInnerAngle
        let toValInner: CGFloat = self.currentChangedInnerAngle + innerRotationAngle
        let animationInner: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        self.currentChangedInnerAngle += innerRotationAngle
        
        animationInner.isRemovedOnCompletion = false
        animationInner.fillMode = CAMediaTimingFillMode.forwards
        animationInner.fromValue = fromValInner
        animationInner.toValue = toValInner
        animationInner.duration = 5.0
        
        outerChartView.layer.add(animationOuter, forKey: "animationOuter")
        innerChartView.layer.add(animationInner, forKey: "animationInner")
        
        var outerResult: String? = nil
        var innerResult: String? = nil
        
        let outerDisplacement = self.currentChangedOuterAngle.truncatingRemainder(dividingBy: cgPi * 2)
        // NOTE: innerは針の位置が180度ずれているため、cgPiを加算する
        let innerDisplacement = (self.currentChangedInnerAngle + cgPi).truncatingRemainder(dividingBy: cgPi * 2)
        
        let outerItemsCount = self.outerCellName.count
        let outerUnitDisplacement = cgPi * 2 / CGFloat(outerItemsCount)
        if outerItemsCount > 0 {
            for i in 0 ..< outerItemsCount {
                if CGFloat(i) * outerUnitDisplacement ..< CGFloat(i+1)*outerUnitDisplacement ~= outerDisplacement {
                    outerResult = self.outerCellName[i]
                }
            }
        }
        
        let innerItemsCount = self.innerCellName.count
        let innerUnitDisplacement = cgPi * 2 / CGFloat(innerItemsCount)
        if innerItemsCount > 0 {
            for i in 0 ..< innerItemsCount {
                if CGFloat(i) * innerUnitDisplacement ..< CGFloat(i+1)*innerUnitDisplacement ~= innerDisplacement {
                    innerResult = self.innerCellName[i]
                }
            }
        }
        
        if DRUserHelper.isAuthorizedResultView {
            self.setupResultLabel(outerResult: outerResult, innerResult: innerResult)
            self.showResultWindow()
        }
        
    }
    
    @IBAction private func shareButton(_ sender: Any) {
        let shareText = "Double Roulette ScreenShot!"
        let shareImage = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: self.bannerView.frame, backgroundColor: self.view.backgroundColor!)
        let activityItems = [shareText, shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func editAnimationSettingButton(_ sender: Any) {
        if let vc = R.storyboard.sub.drRouletteSettingViewController() {
            self.present(vc, animated: true, completion: nil)
        }
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
            print("Error...")
        }
    }
}
