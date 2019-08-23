//
//  TableViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit
import AMColorPicker
import GoogleMobileAds

class TableViewController: UITableViewController, AMColorPickerDelegate, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    
    var itemData = [TableViewCell]()
    var itemName: [String] = []
    var itemColor: [UIColor] = []
    var itemType: [Int] = []
    
    //itemColorの代わりに4つの配列を使用する
    var R: [Double] = []
    var G: [Double] = []
    var B: [Double] = []
    var A: [Double] = []
    
    var indexPath: NSIndexPath!
    
    //storage
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //広告
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        //デバイスID : "01fa9aa834a520d7ce4f9ccc98ab3993"
        //本物
        bannerView.adUnitID = "ca-app-pub-6492692627915720/6248802323"
        //テスト
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let cellNum = userDefaults.integer(forKey: "itemDataNum")
        itemName = userDefaults.object(forKey: "itemName") as? [String] ?? []
        itemType = userDefaults.object(forKey: "itemType") as? [Int] ?? []
        
        R = userDefaults.object(forKey: "R") as? [Double] ?? []
        G = userDefaults.object(forKey: "G") as? [Double] ?? []
        B = userDefaults.object(forKey: "B") as? [Double] ?? []
        A = userDefaults.object(forKey: "A") as? [Double] ?? []
        //print(R)
        //print(G)
        //print(B)
        //print(A)
        
        for _ in 0..<cellNum {
            let item = TableViewCell()
            self.itemData.insert(item, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            //self.itemName.insert(item.name, at: 0)
            self.itemColor.insert(item.color, at: 0)
            //self.itemType.insert(item.type, at: 0)
        }
        //print(cellNum)
        //cell height
        configureTableView()
    }
    
    func configureTableView() {
        tableView.rowHeight = 60
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    //Add Button
    @IBAction func addButtonTapped(_ sender: Any) {
        //prepare  new cell
        let item = TableViewCell()
        //insert new cell
        self.itemData.insert(item, at: 0)
        self.itemName.insert(item.name, at: 0)
        self.itemColor.insert(item.color, at: 0)
        self.itemType.insert(item.type, at: 0)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        item.color.getRed(&r, green: &g , blue: &b, alpha: &a)
        
        self.R.insert(Double(r), at: 0)
        self.G.insert(Double(g), at: 0)
        self.B.insert(Double(b), at: 0)
        self.A.insert(Double(a), at: 0)
        //alert to tableView
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
        //save cells
        saveData()
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        //save cells
        saveData()
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }
    
    @IBAction func buttonButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TableViewCell {
                    self.indexPath = tableView.indexPath(for: cell) as NSIndexPath?
                }
            }
        }
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = UIColor.red
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true, completion: nil)
        
    }
    
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        self.tableView.cellForRow(at: indexPath as IndexPath)?.contentView.viewWithTag(2)?.backgroundColor = color
        
        //save cells
        saveData()
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }
    
    
    //cell delete func
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //ToDoリストから削除
            self.itemData.remove(at: indexPath.row)
            //セル情報の削除
            self.itemName.remove(at: indexPath.row)
            self.itemColor.remove(at: indexPath.row)
            self.itemType.remove(at: indexPath.row)
            
            self.R.remove(at: indexPath.row)
            self.G.remove(at: indexPath.row)
            self.B.remove(at: indexPath.row)
            self.A.remove(at: indexPath.row)
            
            //セルを削除
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        //save cells
        saveData()
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }

    // MARK: - Table view data source

    //return cell's section num
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //return cell num
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemData.count
    }

    //return cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
        //reflect setting
        if itemData.count > 0 {
            cell.itemType.selectedSegmentIndex = self.itemType[indexPath.row]
            cell.itemName.text = self.itemName[indexPath.row]
            cell.itemColor.backgroundColor = UIColor.init(red: CGFloat(self.R[indexPath.row]), green: CGFloat(self.G[indexPath.row]), blue: CGFloat(self.B[indexPath.row]), alpha: CGFloat(self.A[indexPath.row]))
        }
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toViewController") {
            for i in 0..<itemData.count {
                let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
                self.itemName[i] = field?.text ?? ""
                let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
                self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.red
                let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
                self.itemType[i] = type?.selectedSegmentIndex ?? 0
            }
            
            let controller = segue.destination as! ViewController
            controller.itemData = self.itemData
            controller.itemName = self.itemName
            controller.itemColor = self.itemColor
            controller.itemType = self.itemType
        }else if(segue.identifier == "toColorPicker") {
        }
        
        //save cells
        saveData()
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }
    
    func saveData() {
        for i in 0..<itemData.count {
            let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
            self.itemName[i] = field?.text ?? ""
            let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
            self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.red
            let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
            self.itemType[i] = type?.selectedSegmentIndex ?? 0
            
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.itemColor[i].getRed(&r, green: &g , blue: &b, alpha: &a)
            self.R[i] = Double(r)
            self.G[i] = Double(g)
            self.B[i] = Double(b)
            self.A[i] = Double(a)
        }
    }
}
