//
//  OrderListForWaiter.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/12/6.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

struct OrderListForWaiter {
    var orderID: String
    var tableID: String
    var items: [String]
    var itemsQty: [Int]
    var setupTime: Timestamp
}
