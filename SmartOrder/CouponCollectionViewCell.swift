//
//  CouponCollectionViewCell.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var couponTitle: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        cardViewInit()
    }
    
    deinit {
        print("CouponCollectionViewCell deinit.")
    }
    
    func cardViewInit() {
        // CornerRadius Setting.
        cardView.layer.cornerRadius = 5
        couponImage.layer.cornerRadius = 5
        couponImage.clipsToBounds = true
        couponImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Shadow setting.
        cardView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowColor = UIColor(red: 44.0 / 255.0, green: 62.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0).cgColor
        
        // Border setting.
        cardView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
        cardView.layer.borderWidth = 0.5
    }
}
