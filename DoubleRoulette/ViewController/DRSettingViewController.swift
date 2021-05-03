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
    
    private let colorStock = ColorModel()
    private var rouletteData: Results<RouletteObject>!
    private var newCellId: Int = 0
    private var edittingData: RouletteObject?
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = R.color.navigationItemColor()
        self.setupAdvertisement()
        self.setupTableView()
        self.roadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("show_cell_setting_view", parameters: nil)
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
        self.tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 80 : 60
    }
    
    private func roadData() {
        self.rouletteData = DRRealmHelper.init().getRouletteData()
        self.newCellId = DRUserHelper.load("id", returnClass: Int.self) ?? 0
        self.tableView.reloadData()
    }
    
    // MARK: - <イベント登録(IBAction)>
    @IBAction private func clearAllButtonTapped(_ sender: Any) {
        DRRealmHelper.init().deleteAll()
        self.tableView.reloadData()
        self.newCellId = 0
        DRUserHelper.save("id", value: 0)
        Analytics.logEvent("all_clear_button", parameters: nil)
    }
    
    @IBAction private func playButtonTapped(_ sender: Any) {
        guard let rouletteVC = R.storyboard.main.drRouletteViewController() else { return }
        self.navigationController?.pushViewController(rouletteVC, animated: true)
    }
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        let newCell = RouletteObject()
        newCell.id = self.newCellId
        
        self.newCellId += 1
        DRUserHelper.save("id", value: self.newCellId)
        
        let colorRGB = UIColor.convertToRGB(self.colorStock.proposeColor(index: self.rouletteData.count))
        newCell.color = UIColor.rgbToHex(red: Int(colorRGB.red * 255), green: Int(colorRGB.green * 255), blue: Int(colorRGB.blue * 255))
        DRRealmHelper.init().add(object: newCell)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: rouletteData.count - 1, section: 0), at: .bottom, animated: true)
        Analytics.logEvent("add_cell_button", parameters: nil)
    }
    
}

// MARK: - <UITableViewを扱うための拡張>
extension DRSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rouletteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteCell") as! DRTableViewCell
        let object = self.rouletteData[indexPath.row]
        let rgb = UIColor.hexToRGB(hex: object.color)
        cell.setupCell(object: object, type: object.type, name: object.item, color: UIColor.rgbToUIColor(red: rgb[0], green: rgb[1], blue: rgb[2]))
        // セグメントをタップした際の挙動
        cell.segmentedControlAction = { object, sender in
            self.edittingData = object
            DRRealmHelper.init().segmentControlUpdate(cell: object, segment: sender)
            Analytics.logEvent("segment_controll_tapped", parameters: nil)
        }
        // テキストフィールド編集時の挙動
        cell.textFieldAction = { object, sender in
            self.edittingData = object
            DRRealmHelper.init().textFieldUpdate(cell: object, textField: sender)
            Analytics.logEvent("text_field_tapped", parameters: nil)
        }
        // セルのカラーボタンをタップした際の挙動
        cell.colorButtonAction = { object in
            self.edittingData = object
            self.showColorPicker()
            Analytics.logEvent("show_color_picker_button", parameters: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DRRealmHelper.init().delete(object: self.rouletteData[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - <AMColorPickerを使うための拡張>
extension DRSettingViewController: AMColorPickerDelegate {
    
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        guard let object = self.edittingData else { return }

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        DRRealmHelper.init().colorButtonUpdate(cell: object, hexColor: UIColor.rgbToHex(red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255)))
        self.tableView.reloadData()
    }
    
    private func showColorPicker() {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = UIColor.red
        colorPickerViewController.delegate = self
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    
}
