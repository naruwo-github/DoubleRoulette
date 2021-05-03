//
//  DRSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/03.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit
// MARK: - <外部フレームワーク>
import AMColorPicker
import CellAnimator
import Firebase
import FirebaseAnalytics
import GoogleMobileAds
import RealmSwift

// MARK: - <ルーレットセルの設定画面(初期画面)>
class DRSettingViewController: UIViewController {
    
    @IBOutlet private weak var topBannerAdView: GADBannerView!
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = R.color.navigationItemColor()
        self.setupAdvertisement()
        self.setupTableView()
    }
    
    // MARK: - <public関数>
    // MARK: - <private関数>
    
    private func setupAdvertisement() {
        self.topBannerAdView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TODO: DRStringSource.init().CellTableVCTopAdID
        self.topBannerAdView.rootViewController = self
        self.topBannerAdView.load(GADRequest())
        
        self.bottomBannerAdView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TODO: DRStringSource.init().CellTableVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.drTableViewCell), forCellReuseIdentifier: "RouletteCell")
        self.tableView.rowHeight = 60
    }
    
}

// MARK: - <UITableViewを扱うための拡張>
extension DRSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: 要修正
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteCell") as! DRTableViewCell
        return cell
    }
    
}
