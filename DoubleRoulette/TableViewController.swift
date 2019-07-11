//
//  TableViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit
import AMColorPicker

class TableViewController: UITableViewController, AMColorPickerDelegate {
    
    var itemData = [TableViewCell]()
    var itemName: [String] = []
    var itemColor: [UIColor] = []
    var itemType: [Int] = []
    
    var indexPath: NSIndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /*
        //例を入れて初期化
        //prepare  new cell
        let item = TableViewCell()
        //item.itemName.text = "A"
        //item.itemColor.backgroundColor = UIColor.red
        //item.itemType.selectedSegmentIndex = 0
        //insert new cell
        self.itemData.insert(item, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
        (self.tableView.cellForRow(at: [0,0])?.contentView.viewWithTag(1) as? UITextField)?.text = "A"
        (self.tableView.cellForRow(at: [0,0])?.contentView.viewWithTag(2) as? UIButton)?.backgroundColor = UIColor.red
        (self.tableView.cellForRow(at: [0, 0])?.contentView.viewWithTag(3) as? UISegmentedControl)?.selectedSegmentIndex = 0
        self.itemName.insert(item.name, at: 0)
        self.itemColor.insert(item.color, at: 0)
        self.itemType.insert(item.type, at: 0)
        itemName[0] = "A"
        itemColor[0] = UIColor.red
        itemType[0] = 0
        
        tableView.reloadData()
 */
        
        //セルの高さ
        configureTableView()
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "itemName") != nil {
            itemName = userDefaults.object(forKey: "itemName") as! [String]
        }
        if userDefaults.object(forKey: "itemColor") != nil {
            itemColor = userDefaults.object(forKey: "itemColor") as! [UIColor]
        }
        if userDefaults.object(forKey: "itemType") != nil {
            itemType = userDefaults.object(forKey: "itemType") as! [Int]
        }
        
        if itemName.count != 0 {
            for i in 0..<itemName.count {
                //prepare  new cell
                let item = TableViewCell()
                item.itemName.text = itemName[i]
                item.itemColor.backgroundColor = itemColor[i]
                item.itemType.selectedSegmentIndex = itemType[i]
                self.itemData.insert(item, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        
        print(itemName.count)
        //セルの処理をおこなう。tableView.reloadData()とか。
        
        
    }
 */
    
    func configureTableView() {
        tableView.rowHeight = 60
    }
    
    //Add Button
    @IBAction func addButtonTapped(_ sender: Any) {
        //prepare  new cell
        let item = TableViewCell()
        //insert new cell
        self.itemData.insert(item, at: 0)
        //alert to tableView
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
        
        self.itemName.insert(item.name, at: 0)
        self.itemColor.insert(item.color, at: 0)
        self.itemType.insert(item.type, at: 0)
        
        
        /*
        let userDefaults = UserDefaults.standard
        for i in 0..<self.itemData.count {
            let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
            self.itemName[i] = field?.text ?? "Item"
            let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
            self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.red
            let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
            self.itemType[i] = type?.selectedSegmentIndex ?? 0
        }
        userDefaults.set(self.itemName, forKey: "itemName")
        userDefaults.set(self.itemColor, forKey: "itemColor")
        userDefaults.set(self.itemType, forKey: "itemType")
        */
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
        
        /*
        let userDefaults = UserDefaults.standard
        for i in 0..<self.itemData.count {
            let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
            self.itemName[i] = field?.text ?? ""
            let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
            self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.red
            let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
            self.itemType[i] = type?.selectedSegmentIndex ?? 0
        }
        userDefaults.set(self.itemName, forKey: "itemName")
        userDefaults.set(self.itemColor, forKey: "itemColor")
        userDefaults.set(self.itemType, forKey: "itemType")
 */
    }
    
    
    //cell delete func
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //ToDoリストから削除
            self.itemData.remove(at: indexPath.row)
            //セルを削除
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //セル情報の削除
            self.itemName.remove(at: indexPath.row)
            self.itemColor.remove(at: indexPath.row)
            self.itemType.remove(at: indexPath.row)
           
            
            /*
            //save
            let userDefaults = UserDefaults.standard
            for i in 0..<self.itemData.count {
                let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
                self.itemName[i] = field?.text ?? ""
                let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
                self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.red
                let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
                self.itemType[i] = type?.selectedSegmentIndex ?? 0
            }
            userDefaults.set(self.itemName, forKey: "itemName")
            userDefaults.set(self.itemColor, forKey: "itemColor")
            userDefaults.set(self.itemType, forKey: "itemType")
            */
        }
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
        //return itemName.count
    }

    //return cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
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
    }
}
