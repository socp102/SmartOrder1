//
//  ResultTableViewCell.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/26.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resultSubtotal: UILabel!
    @IBOutlet weak var resultCount: UILabel!
    @IBOutlet weak var resultName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
