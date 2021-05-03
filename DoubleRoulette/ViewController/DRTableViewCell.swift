//
//  DRTableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/03.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <ルーレットセルのクラス>
class DRTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var itemNameTextField: UITextField!
    @IBOutlet private weak var colorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
