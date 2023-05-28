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
import RealmSwift

// MARK: - <ルーレット画面右上ボタンより表示する設定画面のクラス>
class DRTemplateListViewController: UIViewController {
    
    public var cellSelectedAction: (() -> Void)?
    
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var templateData: Results<RouletteListObject>!
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAd()
        self.setupTableView()
        self.templateData = DRRealmHelper.init().getTemplateData()
    }
    
    // MARK: - <private関数>
    
    private func setupAd() {
        self.bottomBannerAdView.adUnitID = DRStringSource.init().TemplateVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.drTemplateTableViewCell), forCellReuseIdentifier: "TemplateCell")
        self.tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 300 : 150
    }
    
    // MARK: - <イベント登録(IBAction)>
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - <テーブルビューを扱うための拡張>
extension DRTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell") as! DRTemplateTableViewCell
        cell.setup(template: self.templateData[indexPath.row])
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = self.templateData[indexPath.row]
        DRRealmHelper.init().deleteRouletteData() // 現在のルーレット(全RouletteObject)を削除
        // selectedDataを元に、RouletteObjectを作成
        selectedData.rouletteList.forEach({
            let rouletteCell = RouletteObject()
            rouletteCell.id = DRRealmHelper.init().getLastRouletteObjectId() + 1
            rouletteCell.type = $0.type
            rouletteCell.item = $0.item
            rouletteCell.color = $0.color
            DRRealmHelper.init().add(object: rouletteCell)
        })
        self.dismiss(animated: true, completion: {
            self.cellSelectedAction?()
        })
    }
    
}
