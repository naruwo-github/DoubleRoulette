//
//  TableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate{
    @IBOutlet weak var itemName: UITextField! // tag = 1
    @IBOutlet weak var itemColor: UIButton! // tag = 2
    @IBOutlet weak var itemType: UISegmentedControl! // tag = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemName.delegate = self
    }
    
    internal func textFieldShouldReturn(_ itemName: UITextField) -> Bool {
        self.itemName.resignFirstResponder()
        return true
    }
}
