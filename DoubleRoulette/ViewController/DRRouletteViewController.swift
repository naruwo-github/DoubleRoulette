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
    
    @IBOutlet private weak var bottomAdView: UIView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var itemsLabel: UILabel!
    @IBOutlet private weak var elementNumLabel: UILabel!
    @IBOutlet private weak var outerChartView: MyPieChartView!
    @IBOutlet private weak var innerChartView: MyPieChartView!
    
    private let INTERSTITIAL_AD_UNIT_ID: String = "ca-app-pub-3940256099942544/4411468910" // テスト広告
//    private let INTERSTITIAL_AD_UNIT_ID: String = "ca-app-pub-6492692627915720/3278021023" // 本番
    private var interstitial: GADInterstitial!
    private let BANNER_AD_UNIT_ID: String = "ca-app-pub-6492692627915720/3283423713"
    private let bannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
    private let popupWindow: UIWindow = .init(frame: UIScreen.main.bounds)
    private let labelFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
    private let popupDuration: Double = 1.0
    
    private var rouletteCells: Results<RouletteObject>!
    private var currentChangedOuterAngle: CGFloat = 0.0
    private var currentChangedInnerAngle: CGFloat = 0.0
    private var outerCellName: [String] = []
    private var outerCellColor: [UIColor] = []
    private var innerCellName: [String] = []
    private var innerCellColor: [UIColor] = []
    
    fileprivate var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdvertisementView()
        
        self.rouletteCells = DRRealmHelper.init().getRouletteData()
        
        self.setupInnerOuterData()
        
        self.setupResultWindow()
        self.setupElementLabels()
        
        self.setupOuterRoulette(outerName: self.outerCellName, outerColor: self.outerCellColor)
        self.setupInnerRoulette(innerName: self.innerCellName, innerColor: self.innerCellColor)
        
        self.drawArrow()
    }
    
    // NavigationController の「戻る/進む」で呼ばれる
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            // 戻る場合
            super.willMove(toParent: nil)
            showInterstitialAd()
            return
        }
        // 進む場合
    }
    
    private func setupInnerOuterData() {
        for cell in self.rouletteCells {
            let hex = cell.color
            let rgb = UIColor.hexToRGB(hex: hex)
            let cellColor = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            if cell.type == 0 {
                self.outerCellName.insert(cell.item, at: 0)
                self.outerCellColor.insert(cellColor, at: 0)
            } else {
                self.innerCellName.insert(cell.item, at: 0)
                self.innerCellColor.insert(cellColor, at: 0)
            }
        }
    }
    
    private func setupResultWindow() {
        self.popupWindow.windowLevel = UIWindow.Level.normal + 10
        self.popupWindow.alpha = 0
    }
    
    private func setupElementLabels() {
        self.itemsLabel.text = "Items: " + self.rouletteCells.count.description
        self.elementNumLabel.text = "Outer: " + self.outerCellName.count.description + ", Inner: " + self.innerCellName.count.description
    }
    
    private func setupOuterRoulette(outerName: [String], outerColor: [UIColor]) {
        self.outerChartView.radius = min(self.view.frame.size.width, self.view.frame.size.height) / 2
        for i in 0..<outerName.count {
            self.outerChartView.segments.insert(Segment(color: outerColor[i], value: .pi * 2.0 / CGFloat(outerName.count)), at: 0)
        }
        self.setupOuterRouletteLabel()
    }
    
    private func setupInnerRoulette(innerName: [String], innerColor: [UIColor]) {
        self.innerChartView.radius = min(self.view.frame.size.width, self.view.frame.size.height) / 4
        for i in 0..<innerName.count {
            self.innerChartView.segments.insert(Segment(color: innerColor[i], value: .pi * 2.0 / CGFloat(innerName.count)), at: 0)
        }
        self.setupInnerRouletteLabel()
    }
    
    private func setupOuterRouletteLabel() {
        let angleOfOuterPiece = .pi * 2.0 / CGFloat(self.outerCellName.count)
        let distFromOuterCenter = self.view.frame.width * 3 / 8
        let startPoint = self.view.center
        let firstOuterLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromOuterCenter)
        for i in 0..<self.outerCellName.count {
            let coefficientI = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.view.frame.width / 13)
            sampleLabel.text = self.outerCellName[i]
            sampleLabel.adjustsFontSizeToFitWidth = true
            sampleLabel.textAlignment = .center
            sampleLabel.backgroundColor = UIColor.clear
            sampleLabel.textColor = R.color.rouletteLabel()
            sampleLabel.numberOfLines = 0
            let x = firstOuterLabelPoint.x - startPoint.x
            let y = firstOuterLabelPoint.y - startPoint.y
            let nextx = cos(-(angleOfOuterPiece * coefficientI + angleOfOuterPiece / 2)) * x - sin(-(angleOfOuterPiece * coefficientI + angleOfOuterPiece / 2)) * y + startPoint.x
            let nexty = sin(-(angleOfOuterPiece * coefficientI + angleOfOuterPiece / 2)) * x + cos(-(angleOfOuterPiece * coefficientI + angleOfOuterPiece / 2)) * y + startPoint.y
            sampleLabel.center = CGPoint(x: nextx, y: nexty)
            self.outerChartView.addSubview(sampleLabel)
        }
    }
    
    private func setupInnerRouletteLabel() {
        let startPoint = self.view.center
        let angleOfInnerPiece = .pi * 2.0 / CGFloat(self.innerCellName.count)
        let distFromInnerCenter = self.view.frame.width / 6.5
        let firstInnerLabelPoint = CGPoint(x: startPoint.x, y: startPoint.y - distFromInnerCenter)
        for i in 0..<self.innerCellName.count {
            let coefficientI = CGFloat(i)
            let sampleLabel = UILabel()
            sampleLabel.font = UIFont.init(name: "HiraginoSans-W3", size: self.labelFontSize)
            sampleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 7, height: self.view.frame.width / 14)
            sampleLabel.text = self.innerCellName[i]
            sampleLabel.adjustsFontSizeToFitWidth = true
            sampleLabel.textAlignment = .center
            sampleLabel.backgroundColor = UIColor.clear
            sampleLabel.textColor = R.color.rouletteLabel()
            sampleLabel.numberOfLines = 0
            let x = firstInnerLabelPoint.x - startPoint.x
            let y = firstInnerLabelPoint.y - startPoint.y
            let nextx = cos(-(angleOfInnerPiece * coefficientI + angleOfInnerPiece / 2)) * x - sin(-(angleOfInnerPiece * coefficientI + angleOfInnerPiece / 2)) * y + startPoint.x
            let nexty = sin(-(angleOfInnerPiece * coefficientI + angleOfInnerPiece / 2)) * x + cos(-(angleOfInnerPiece * coefficientI + angleOfInnerPiece / 2)) * y + startPoint.y
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
        
        self.view.bringSubviewToFront(arrowView)
        self.view.addSubview(arrowView)
    }
    
    private func showInterstitialAd() {
        guard let ad = interstitial else { return }
        let backCount = DRUserHelper.backToCellSettingFromRouletteCount
        if backCount != 0 && backCount % 7 == 0 {
            if ad.isReady {
                ad.present(fromRootViewController: self)
            }
        }
        DRUserHelper.backToCellSettingFromRouletteCount = backCount + 1
    }
    
    private func soundOnIfNeed() {
        if DRUserHelper.isAuthorizedPlaySound {
            self.playSound(name: "roulette-sound")
        }
    }
    
    private func setupOuterChartView() {
        let rotationMinimum: CGFloat = .pi * 2
        let outerRotationAngle: CGFloat = .random(in: rotationMinimum ... .pi * 2 * 10)
        let fromValOuter: CGFloat = self.currentChangedOuterAngle
        let toValOuter: CGFloat = self.currentChangedOuterAngle + outerRotationAngle
        let animationOuter: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        self.currentChangedOuterAngle += outerRotationAngle
        
        animationOuter.isRemovedOnCompletion = false
        animationOuter.fillMode = CAMediaTimingFillMode.forwards
        animationOuter.fromValue = fromValOuter
        animationOuter.toValue = toValOuter
        animationOuter.duration = 4.0
        self.outerChartView.layer.add(animationOuter, forKey: "animationOuter")
    }
    
    private func setupInnerChartView() {
        let rotationMinimum: CGFloat = .pi * 2
        let innerRotationAngle: CGFloat = .random(in: rotationMinimum ... .pi * 2 * 10)
        let fromValInner: CGFloat = self.currentChangedInnerAngle
        let toValInner: CGFloat = self.currentChangedInnerAngle + innerRotationAngle
        let animationInner: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        self.currentChangedInnerAngle += innerRotationAngle
        
        animationInner.isRemovedOnCompletion = false
        animationInner.fillMode = CAMediaTimingFillMode.forwards
        animationInner.fromValue = fromValInner
        animationInner.toValue = toValInner
        animationInner.duration = 5.0
        self.innerChartView.layer.add(animationInner, forKey: "animationInner")
    }
    
    private func showResultLabelIfNeed(outerResult: String?, innerResult: String?) {
        guard DRUserHelper.isAuthorizedResultView,
              let vc = R.storyboard.popup.drResultViewController() else { return }
        vc.outer = outerResult
        vc.inner = innerResult
        self.popupWindow.rootViewController = vc
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.popupWindow.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            UIView.animate(withDuration: self.popupDuration) {
                self.popupWindow.alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: self.popupDuration) {
                    self.popupWindow.alpha = 0
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
            self.view.window?.makeKeyAndVisible()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        self.soundOnIfNeed()
        
        self.setupOuterChartView()
        self.setupInnerChartView()
        
        var outerResult: String?
        var innerResult: String?
        
        let outerDisplacement: CGFloat = self.currentChangedOuterAngle.truncatingRemainder(dividingBy: .pi * 2)
        // innerは針の位置が180度ずれているため、CGFloat.piを加算する
        let innerDisplacement: CGFloat = (self.currentChangedInnerAngle + .pi).truncatingRemainder(dividingBy: .pi * 2)
        
        let outerItemsCount = self.outerCellName.count
        let outerUnitDisplacement = .pi * 2 / CGFloat(outerItemsCount)
        if outerItemsCount > 0 {
            for i in 0 ..< outerItemsCount {
                if CGFloat(i) * outerUnitDisplacement ..< CGFloat(i+1)*outerUnitDisplacement ~= outerDisplacement {
                    outerResult = self.outerCellName[i]
                }
            }
        }
        
        let innerItemsCount = self.innerCellName.count
        let innerUnitDisplacement = .pi * 2 / CGFloat(innerItemsCount)
        if innerItemsCount > 0 {
            for i in 0 ..< innerItemsCount {
                if CGFloat(i) * innerUnitDisplacement ..< CGFloat(i+1)*innerUnitDisplacement ~= innerDisplacement {
                    innerResult = self.innerCellName[i]
                }
            }
        }
        
        self.showResultLabelIfNeed(outerResult: outerResult, innerResult: innerResult)
    }
    
    @IBAction private func editAnimationSettingButton(_ sender: Any) {
        guard let vc = R.storyboard.sub.drRouletteSettingViewController() else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension DRRouletteViewController: GADInterstitialDelegate {
    
    fileprivate func setupAdvertisementView() {
        self.interstitial = GADInterstitial(adUnitID: self.INTERSTITIAL_AD_UNIT_ID)
        self.interstitial.load(GADRequest())
        self.interstitial.delegate = self
        
        self.bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.bottomAdView.addSubview(self.bannerView)
        self.bannerView.center.x = self.view.center.x
        self.bannerView.adUnitID = self.BANNER_AD_UNIT_ID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    // Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    // Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    // Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    // Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    // Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
    }

    // Tells the delegate that a user click will open another app
    // (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
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
