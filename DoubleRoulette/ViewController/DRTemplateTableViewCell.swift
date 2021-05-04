//
//  DRTemplateTableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/04.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <テンプレートセルのクラス>
class DRTemplateTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - <ライフサイクル>
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - <public関数>
    
    public func setup(title: String) {
        self.titleLabel.text = title
    }
    
    // MARK: - <private関数>
    
}
