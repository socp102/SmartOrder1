//
//  FoodTableViewCell.swift
//  Menu
//
//  Created by Lu Kevin on 2018/11/18.
//  Copyright © 2018年 Lu Kevin. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodNmae: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
