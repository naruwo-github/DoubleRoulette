//
//  ViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import AVFoundation
import UIKit
// MARK: - <外部フレームワーク>
import Firebase
import FirebaseAnalytics
import GoogleMobileAds
import RealmSwift

// MARK: - <ルーレット画面のクラス>
class DRRouletteViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var itemsLabel: UILabel!
    @IBOutlet private weak var elementNumLabel: UILabel!
    @IBOutlet private weak var outerChartView: PieChartView!
    @IBOutlet private weak var innerChartView: PieChartView!
    @IBOutlet private weak var balloonView: DRPopupWithBalloonView!
    
    private var interstitial: GADInterstitialAd?
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
    private var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAd()
        self.rouletteCells = DRRealmHelper.init().getRouletteData()
        self.classifyInnerOuterData()
        self.setupResultWindow()
        self.setupElementLabels()
        self.setupOuterRoulette(outerName: self.outerCellName, outerColor: self.outerCellColor)
        self.setupInnerRoulette(innerName: self.innerCellName, innerColor: self.innerCellColor)
        self.drawArrow()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil { // 戻る場合
            super.willMove(toParent: nil)
            self.showInterstitialAd()
            return
        }
        // 進む場合
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent("show_roulette_view", parameters: nil)
        guard !DRUserHelper.isShownAnimationSettingView else { return }
        
        if !DRUserHelper.isShownPopupOfAnimationSetting {
            DRUserHelper.isShownPopupOfAnimationSetting = true
            self.balloonView.show(fillColor: .orange, title: "Animation Setting")
        } else if Int.random(in: 0...4) == Int.random(in: 0...4) {
            self.balloonView.show(fillColor: .orange, title: "Animation Setting")
        }
    }
    
    private func classifyInnerOuterData() {
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
        let topArrow = R.image.arrow1()
        topImageView.image = topArrow
        topImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - self.view.frame.width/2)
        
        let bottomImageView = UIImageView()
        bottomImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/9, height: self.view.frame.height/4.5)
        let bottomArrow = R.image.arrow2()
        bottomImageView.image = bottomArrow
        bottomImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + self.view.frame.width*3/8)
        
        arrowView.addSubview(topImageView)
        arrowView.addSubview(bottomImageView)

        self.view.bringSubviewToFront(arrowView)
        self.view.addSubview(arrowView)
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
        
        self.view.isUserInteractionEnabled = false
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
            self.view.isUserInteractionEnabled = true
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
            for i in 0 ..< outerItemsCount
            where CGFloat(i) * outerUnitDisplacement ..< CGFloat(i+1)*outerUnitDisplacement ~= outerDisplacement {
                outerResult = self.outerCellName[i]
            }
        }
        
        let innerItemsCount = self.innerCellName.count
        let innerUnitDisplacement = .pi * 2 / CGFloat(innerItemsCount)
        if innerItemsCount > 0 {
            for i in 0 ..< innerItemsCount
            where CGFloat(i) * innerUnitDisplacement ..< CGFloat(i+1)*innerUnitDisplacement ~= innerDisplacement {
                innerResult = self.innerCellName[i]
            }
        }
        
        self.showResultLabelIfNeed(outerResult: outerResult, innerResult: innerResult)
        Analytics.logEvent("start_button", parameters: nil)
    }
    
    @IBAction private func editAnimationSettingButtonTapped(_ sender: Any) {
        guard let vc = R.storyboard.modal.drRouletteSettingViewController() else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - <広告利用のための拡張>
extension DRRouletteViewController: GADFullScreenContentDelegate {
    
    private func setupAd() {
        self.bottomBannerAdView.adUnitID = DRStringSource.init().RouletteVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
        self.bottomBannerAdView.delegate = self
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: DRStringSource.init().RouletteVCInterstitialAdID,
                               request: request,
                               // ここは[unowned self]ではメモリが開放されててエラーになるので[self]とする
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                self.interstitial = ad
                                self.interstitial?.fullScreenContentDelegate = self
                               }
        )
    }
    
    private func showInterstitialAd() {
        let backCount = DRUserHelper.backToCellSettingFromRouletteCount
        if backCount != 0 && backCount % 7 == 0 {
            if self.interstitial != nil {
                self.interstitial!.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
        DRUserHelper.backToCellSettingFromRouletteCount = backCount + 1
    }
    
}

// MARK: - <音楽再生機能のための拡張>
extension DRRouletteViewController: AVAudioPlayerDelegate {
    
    private func playSound(name: String) {
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
    
    private func soundOnIfNeed() {
        if DRUserHelper.isAuthorizedPlaySound {
            self.playSound(name: "roulette-sound")
        }
    }
    
}
