//
//  TableViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import AdSupport
import AppTrackingTransparency
import UIKit

import AMColorPicker
import CellAnimator
import Firebase
import FirebaseAnalytics
import GoogleMobileAds
import RealmSwift

// MARK: - <ルーレットセルの設定画面(初期画面)>
class DRRouletteCellTableViewController: UITableViewController, GADBannerViewDelegate {
    
    @IBOutlet private weak var adView: UIView!
    @IBOutlet private weak var addCellButton: UIBarButtonItem!
    @IBOutlet private weak var moveToRouletteButton: UIBarButtonItem!
    
    private let AD_UNIT_ID: String = "ca-app-pub-6492692627915720/2967728941"
    private let bannerView: GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
    private let colorStock = ColorStock()
    
    private var indexPath: NSIndexPath?
    private var newCellId: Int = 0
    private var rouletteCells: Results<RouletteObject>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = R.color.navigationItemColor()
        self.configureTableView()
        
        self.rouletteCells = DRRealmHelper.init().getRouletteData()
        self.newCellId = DRUserHelper.load("id", returnClass: Int.self) ?? 0
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureAdvertisementView()
        Analytics.logEvent("show_cell_setting_view", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 14, *) { // iOS14.0以降
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                print("😭拒否")
            case .restricted:
                print("🥺制限")
            case .notDetermined:
                self.showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        } else { // iOS14未満
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            } else {
                print("🥺制限")
            }
        }
    }
    
    // Alert表示
    private func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                case .denied, .restricted, .notDetermined:
                    print("😭")
                @unknown default:
                    fatalError()
                }
            })
        }
    }
    
    @IBAction private func allClearButtonTapped(_ sender: Any) {
        DRRealmHelper.init().deleteAll()
        self.tableView.reloadData()
        self.newCellId = 0
        DRUserHelper.save("id", value: 0)
        Analytics.logEvent("all_clear_button", parameters: nil)
    }
    
    @IBAction private func addCellButtonTapped(_ sender: Any) {
        let newCell = RouletteObject()
        newCell.id = self.newCellId
        
        self.newCellId += 1
        DRUserHelper.save("id", value: self.newCellId)
        
        let colorRGB = UIColor.convertToRGB(self.colorStock.proposeColor(index: self.rouletteCells.count))
        newCell.color = UIColor.rgbToHex(red: Int(colorRGB.red * 255), green: Int(colorRGB.green * 255), blue: Int(colorRGB.blue * 255))
        DRRealmHelper.init().add(object: newCell)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: rouletteCells.count - 1, section: 0), at: .bottom, animated: true)
        Analytics.logEvent("add_cell_button", parameters: nil)
    }
    
    @IBAction private func moveToRouletteButtonTapped(_ sender: Any) {
        guard let rouletteVC = R.storyboard.main.drRouletteViewController() else { return }
        self.navigationController?.pushViewController(rouletteVC, animated: true)
    }
    
    @IBAction private func cellColorButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton,
           let superview = button.superview,
           let cell = superview.superview as? TableViewCell {
            self.indexPath = tableView.indexPath(for: cell) as NSIndexPath?
        }
        self.showColorPicker()
        Analytics.logEvent("show_color_picker_button", parameters: nil)
    }
    
    @IBAction private func segmentedControlTapped(_ sender: UISegmentedControl) {
        let point = self.tableView.convert(sender.center, from: sender)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else { return }
        let cell = rouletteCells[indexPath.row]
        DRRealmHelper.init().segmentControlUpdate(cell: cell, segment: sender)
        Analytics.logEvent("segment_controll_tapped", parameters: nil)
    }
    
    @IBAction private func textField(_ sender: UITextField) {
        let point = self.tableView.convert(sender.center, from: sender)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else { return }
        let cell = rouletteCells[indexPath.row]
        DRRealmHelper.init().textFieldUpdate(cell: cell, textField: sender)
        Analytics.logEvent("text_field_tapped", parameters: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DRRealmHelper.init().delete(object: self.rouletteCells[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let object = self.rouletteCells[indexPath.row]
        let rgb = UIColor.hexToRGB(hex: object.color)
        cell.setupCell(name: object.item, color: UIColor.rgbToUIColor(red: rgb[0], green: rgb[1], blue: rgb[2]), type: object.type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rouletteCells.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func configureTableView() {
        self.tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 55
    }
    
    private func configureAdvertisementView() {
        self.bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.adView.addSubview(self.bannerView)
        self.bannerView.center.x = self.view.center.x
        self.bannerView.adUnitID = self.AD_UNIT_ID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
}

// MARK: - <AMColorPickerを使うための拡張>
extension DRRouletteCellTableViewController: AMColorPickerDelegate {
    
    internal func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        guard self.indexPath != nil else { return }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let cell = self.rouletteCells[self.indexPath!.row]
        DRRealmHelper.init().colorButtonUpdate(cell: cell, hexColor: UIColor.rgbToHex(red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255)))
        let modifiedCell = self.tableView.cellForRow(at: self.indexPath! as IndexPath)
        (modifiedCell?.viewWithTag(2) as! UIButton).backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    fileprivate func showColorPicker() {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = UIColor.red
        colorPickerViewController.delegate = self
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    
}
