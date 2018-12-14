//
//  OrderListDetialTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class OrderListDetialTableViewController: UITableViewController {
    let communicator = FirebaseCommunicator.shared
    var detialobject = Order()

    override func viewDidLoad() {
        super.viewDidLoad()
        setvalue()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setvalue()
    }
    @IBOutlet weak var detialtime: UILabel!
    @IBOutlet weak var detialItem: UITextView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var couponDetial: UILabel!
    @IBOutlet weak var finialtotal: UILabel!
  
    // MARK: - Table view data source

    
    func setvalue() {
        detialtime.text = self.detialobject.time
        detialItem.text = "\(self.detialobject.itemName.name)  數量：\(self.detialobject.itemName.detialitem.count)"
        total.text = self.detialobject.itemName.detialitem.subtotle
        finialtotal.text = "折扣後金額： \(self.detialobject.total) 元"
        couponDetial.text = self.detialobject.coupon
    }
    
}
