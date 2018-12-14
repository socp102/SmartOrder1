//
//  CouponInfo.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation

struct CouponInfo: Codable {
    var couponID: String
    var couponTitle: String
    var couponImageName: String
    var couponDetilContent: String
    var couponQty: Int
    var couponDiscount: Double
    var couponValidDate: String
}
