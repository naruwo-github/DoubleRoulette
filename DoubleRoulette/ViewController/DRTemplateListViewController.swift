//
//  DRTemplateListViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/04.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <外部フレームワーク>
import GoogleMobileAds

// MARK: - <ルーレット画面右上ボタンより表示する設定画面のクラス>
class DRTemplateListViewController: UIViewController {
    
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAdvertisement()
    }
    
    private func setupAdvertisement() {
        self.bottomBannerAdView.adUnitID = DRStringSource.init().TemplateVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
    }
    
}

// MARK: - <テーブルビューを扱うための拡張>
extension DRTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO:
        return UITableViewCell()
    }
    
    
}
