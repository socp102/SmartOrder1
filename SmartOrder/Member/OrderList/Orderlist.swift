//
//  Orderlist.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/11.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation

struct Order {
    var itemName = Items.init(name: "", detialitem: detial.init())
    var time = ""
    var total:String = ""
    var coupon = ""
    
    
}

struct Items {
    var name = " "
    var detialitem = detial.init()
}

struct detial {
    var count = ""
    var subtotle = ""
    
}

