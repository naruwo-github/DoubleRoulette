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
import CellAnimator
import GoogleMobileAds
import RealmSwift

// MARK: - <ルーレット画面右上ボタンより表示する設定画面のクラス>
class DRTemplateListViewController: UIViewController {
    
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var templateData: Results<RouletteListObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAdvertisement()
        self.setupTableView()
        self.templateData = DRRealmHelper.init().getTemplateData()
    }
    
    private func setupAdvertisement() {
        self.bottomBannerAdView.adUnitID = DRStringSource.init().TemplateVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.drTemplateTableViewCell), forCellReuseIdentifier: "TemplateCell")
        self.tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 100
    }
    
}

// MARK: - <テーブルビューを扱うための拡張>
extension DRTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell") as! DRTemplateTableViewCell
        cell.setup(title: self.templateData[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let template = self.templateData[indexPath.row]
            template.rouletteList.forEach({
                DRRealmHelper.init().delete(object: $0)// templateに紐づくオブジェクトを削除
            })
            DRRealmHelper.init().delete(object: template) // templateオブジェクト自体を削除
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
}
