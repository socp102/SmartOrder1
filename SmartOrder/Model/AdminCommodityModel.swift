//
//  AdminCommodityModel.swift
//  SmartOrder
//
//  Created by 9S on 2018/12/5.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

struct FireOrderData {
    var commodity: [ProductModel]
    var timestamp: Timestamp
    var total: Int
}

struct ProductModel {
    var name: String
    var count: Int
    var subtotal: Int
}






