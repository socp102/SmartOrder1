//
//  OrderListTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class OrderListTableViewController: UITableViewController {

    
    var orderinfo : [String:Any] = [ "" : 0 ]
    var object = Order()
    var objects = [Order]()
    
    var firebaseCommunicator = FirebaseCommunicator.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        tableView.tableFooterView = UIView()
        getCouponInfo(user: currentUser.uid)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objects.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = objects[section]
        return item.time
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "ordercell", for: indexPath)
        let item = objects[indexPath.section]
        cell.detailTextLabel?.text = "$ \(item.total) 元"
        return cell
    }
    
    //下載資料
    
    func getCouponInfo(user: String) {
        firebaseCommunicator.loadData(collectionName: "order", field: "userID", condition: user) { (result, error) in
            
            if let error = error {
                print("error:\(error)")
            }
            var keys = ""
            var info = result as! [String:Any]
            info.forEach({ (key, value) in
                keys = key
                self.orderinfo = info[keys] as! [String : Any]
                //總額
                self.object.total = (self.orderinfo["total"])! as! String
                //date
                let FIRServerValue = (self.orderinfo["timestamp"])! as! Timestamp
                //print("FIRServerValue: \(FIRServerValue)")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
                let orderTime = Double(FIRServerValue.seconds)
                let date = dateFormatter.string(from: Date(timeIntervalSince1970: orderTime))
                self.object.time = date
                
                //第三層
                let orderitem = (self.orderinfo["allOrder"])! as! [String:[String:Any]]
                
                //如果不使用優惠券
                guard self.orderinfo["coupon"] != nil else {
                    
                    self.object.itemName.detialitem.subtotle = self.object.total
                    
                    for item in orderitem.keys {
                        self.object.itemName.name = item
                        let detialitem = orderitem[item]
                        self.object.itemName.detialitem.count = (detialitem!["count"]!) as! String
                    }
                    
                    self.objects.append(self.object)
                    print("objects: \(self.objects)")
                    self.tableView.reloadData()
                    return
                }
                self.object.coupon = (self.orderinfo["coupon"])! as! String
                
                //明細
                
                for item in orderitem.keys {
                    self.object.itemName.name = item
                    let detialitem = orderitem[item]
                    self.object.itemName.detialitem.count = (detialitem!["count"]!) as! String
                    self.object.itemName.detialitem.subtotle = (detialitem!["subtotal"]!) as! String
                }
                
                //上傳
                self.objects.append(self.object)
                //print("objects: \(self.objects)")
                self.tableView.reloadData()
            })

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OrderListDetialTableViewController {
            let controller = segue.destination as! OrderListDetialTableViewController
//            let detialobject = self.objects
//            controller.detialobject = detialobject
            let indexPath = self.tableView.indexPathForSelectedRow
            let courseSelect = objects[indexPath!.row]
            controller.detialobject = courseSelect
        }
    }
    
    
    
}
