//
//  CoponViewTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/10.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class CoponViewTableViewController: UITableViewController {
   
    var firebaseCommunicator = FirebaseCommunicator.shared
    var couponInfo : [String:[String:Any]] = ["":["":0]]
    var currentItem = Coupon(title: "", imagename: "", couponValidDate: "", couponDiscount: 0.0, couponDetilContent: "", ower: "")
    var objects = [Coupon]()
    var doesnhascoupon = true

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        getCouponInfo(user: currentUser.uid)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objects.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = objects[section]
        
        return item.title
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
   
    //cell 資料設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "couponlist", for: indexPath)
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        let item = objects[indexPath.section]
        var unit = ""
        
        let subtitlelabel = cell.viewWithTag(123) as! UILabel
        let discountlabel = cell.viewWithTag(789) as! UILabel
        let date = cell.viewWithTag(456) as! UILabel
        //副標題
        subtitlelabel.text = "\(item.couponDetilContent)"
        //時間
       
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let time = formatter.string(from: currentDate)
        let date2 = item.couponValidDate
        if time.compare(date2) == .orderedDescending {
            cell.backgroundColor = .gray
            cell.alpha = 0.5
        }
        date.text = "到期：\(item.couponValidDate)"
        if item.couponDiscount >= 1{
            unit = "- \(item.couponDiscount) 元"
        } else {
            unit = "\(item.couponDiscount) 折"
        }
        discountlabel.text = unit
        // 圖
        let catPicture = downimage(image: item.imagename)
        var imageV = UIImageView()
        imageV = cell.viewWithTag(101) as! UIImageView
        imageV.image = catPicture
        
        return cell
    }
    //下載
    func getCouponInfo(user: String) {
        
        //抓優惠卷資料
        firebaseCommunicator.loadData(collectionName: "couponInfo") { (result, error) in
            if let error = error {
                print("error:\(error)")
            }
            guard let result = result else {
                print("result is nil")
                return
            }
            self.couponInfo = result as! [String:[String:Any]]
            
            let couponCollection = Array(self.couponInfo.keys)
            //print("couponCollection: \(couponCollection)")
            self.objects = self.object(couponCollection: couponCollection,user: user)
            
            //print("objectitem1: \(self.objects)")
            self.tableView.reloadData()
        }
        
        
    }
    
    func downimage(image:String) -> UIImage{
        //圖片
        var images = UIImage(named: "background")
        firebaseCommunicator.downloadImage(url: "couponImages/", fileName: image) { (result, error ) in
            if let error = error {
                print("圖片下載錯誤:\(error)")
            }
            guard let result = result else {
                print("result is nil")
                return
            }
            images = (result as! UIImage)
            
        }

        return images!
        
    }
    
    
    
    //查詢
    func object(couponCollection: [String],user: String) -> [Coupon] {
        var object = [Coupon]()
        for reviewCoupon in  couponCollection {
            var couponReview = self.couponInfo["\(reviewCoupon)"]
            let couponOwner = couponReview?["owner"]
            let couponOwnerNSDictionary = couponOwner as? NSDictionary
            let couponDictionaryOptional = couponOwnerNSDictionary as? Dictionary<String, Any>
            let couponOwnerDictionary = couponDictionaryOptional!
            let hasCoupon = couponOwnerDictionary.keys.contains(user)
            
            if hasCoupon == true {
                
                let userCouponValueAny = couponOwnerDictionary[user]
                let userCouponValueInt = userCouponValueAny as! Bool
                
                
                switch userCouponValueInt {
                //領取但還沒用過
                case false:
                    self.currentItem.title = (couponReview?["couponTitle"])! as! String
                    self.currentItem.imagename = (couponReview?["couponImageName"])! as! String
                    self.currentItem.couponDiscount = (couponReview?["couponDiscount"])! as! Double
                    self.currentItem.couponDetilContent = (couponReview?["couponDetilContent"])! as! String
                    self.currentItem.couponValidDate = (couponReview?["couponValidDate"])! as! String
                    object.append(self.currentItem)
                    
                    break
                    
                //領取但已使用過
                case true:
                    self.couponInfo.removeValue(forKey: "\(reviewCoupon)")
                    break
                    
                }
            } else {
                print("hasCoupon == true")
                self.couponInfo.removeValue(forKey: "\(reviewCoupon)")
               
            }
        
        }
        //print("object4: \(object)")
        return object
    }
 
    
    
    
}
