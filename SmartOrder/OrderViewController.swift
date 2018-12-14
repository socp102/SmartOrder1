//
//  OrderViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/12/6.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class OrderViewController: UIViewController {
    @IBOutlet weak var orderCollectionView: UICollectionView!
    
    let firebaseCommunicator = FirebaseCommunicator.shared
    var listener: ListenerRegistration?
    let FIREBASE_COLLECTION_NAME = "order"
    
    var orders = [OrderListForWaiter]()
    var originalCommodities = [String: Any]()
    var animateDelay: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if listener != nil {
            listener!.remove()
            listener = nil
        }
    }
    
    deinit {
        print("OrderViewController deinit.")
    }
    
    // MARK: - Methods.
    func downloadOrderInfo() {
        animateDelay = 0.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        let currentTime = dateFormatter.string(from: Date())
        let reStrLower = currentTime.index(currentTime.startIndex, offsetBy: 0)
        let reStrUpper = currentTime.index(reStrLower, offsetBy: 9)
        let lowerLimmit = String(currentTime[reStrLower...reStrUpper]) + " 00:00:00"
        
        firebaseCommunicator.loadData(collectionName: FIREBASE_COLLECTION_NAME, greaterThanOrEqualTo: lowerLimmit, lessThanOrEqualTo: currentTime) { [weak self] (results, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("Load data error: \(error)")
            } else if let results = results as? [String: Any] {
                print("results \(results)")
                
                // Handle results.
                var orderID = ""
                var tableID = ""
                var commodity: [String: Any] = [:]
                var setupTime = Timestamp()
                strongSelf.orders.removeAll()
                strongSelf.originalCommodities.removeAll()
                results.forEach({ (orderIDKey, orderIDValue) in
                    guard let orderContent = orderIDValue as? [String: Any] else {
                        return
                    }
                    orderID = orderIDKey
                    orderContent.forEach({ (orderContentKey, orderContentValue) in
                        switch orderContentKey {
                        case "tableID":
                            tableID = orderContentValue as! String
                        case "allOrder":
                            commodity = orderContentValue as! [String: Any]
                        case "timestamp":
                            setupTime = orderContentValue as! Timestamp
                        default:
                            break
                        }
                    })
                    strongSelf.originalCommodities.updateValue(commodity, forKey: orderIDKey)
                    handleData(orderID: orderID, tableID: tableID, commodity: commodity, setupTime: setupTime)
                })
                strongSelf.orderCollectionView.reloadData()
            }
        }
        
        func handleData(orderID: String, tableID: String, commodity: [String: Any], setupTime: Timestamp) {
            var items = [String]()
            var itemsQty = [Int]()
            
            commodity.forEach { (key, value) in
                let dictionary = value as! [String: String]
                let qty = Int(dictionary["notReady"]!)!
                if qty > 0 {
                    items.append(itemDecoder(input: key))
                    itemsQty.append(qty)
                }
            }
            if items.count > 0 {
                orders.append(OrderListForWaiter(orderID: orderID, tableID: tableID, items: items, itemsQty: itemsQty, setupTime: setupTime))
            }
            orders.sort(by: { (first, second) -> Bool in
                return first.setupTime.seconds < second.setupTime.seconds
            })
        }
        
        func itemDecoder(input: String) -> String {
            switch input {
            case "BeefHamburger":
                return "牛肉漢堡"
            case "ChickenHamburger":
                return "雞肉漢堡"
            case "PorkHamburger":
                return "豬肉漢堡"
            case "TomatoSpaghetti":
                return "紅醬義大利麵"
            case "PestoSpaghetti":
                return "青醬義大利麵"
            case "CarbonaraSpaghetti":
                return "白醬義大利麵"
            case "CheesePizza":
                return "起司披薩"
            case "TomatoPizza":
                return "番茄披薩"
            case "OlivaPizza":
                return "橄欖披薩"
            case "FiletMigon":
                return "牛菲力"
            case "RibeyeSteak":
                return "牛肋排"
            case "GrilledSteak":
                return "炙燒牛排"
            case "Macaron":
                return "馬卡龍"
            case "ChocolateCake":
                return "巧克力蛋糕"
            case "Sundae":
                return "聖代"
            default:
                return "unknown"
            }
        }
    }
    
    func addListener() {
        if let db = firebaseCommunicator.db, listener == nil {
            listener = db.collection(FIREBASE_COLLECTION_NAME).addSnapshotListener { [weak self] querySnapshot, error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("AddSnapshotListener error: \(error)")
                } else {
                    print("AddSnapshotListener successful.")
                    strongSelf.downloadOrderInfo()
                }
            }
        }
    }
    
    // MARK: - Handle button.
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        downloadOrderInfo()
    }
}

extension OrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitle = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "orderSection", for: indexPath) as? OrderSectionCollectionReusableView else {
            return UICollectionReusableView()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        let orderTime = Double(orders[indexPath.section].setupTime.seconds)
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: orderTime))
        sectionTitle.sectionTitle.text = "第 \(orders[indexPath.section].tableID) 桌"
        sectionTitle.orderTime.text = "點餐時間: \(date)"
        return sectionTitle
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as? OrderCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.item.text = orders[indexPath.section].items[indexPath.row]
        cell.itemQty.text = "未上菜: \(orders[indexPath.section].itemsQty[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        orders[indexPath.section].itemsQty[indexPath.row] -= 1
        
        let item = orders[indexPath.section].items[indexPath.row]
        let value = orders[indexPath.section].itemsQty[indexPath.row]
        
        var commodity = originalCommodities[orders[indexPath.section].orderID] as! [String: Any]
        var itemContent = commodity[itemEncoder(input: item)] as! [String: String]
        itemContent["notReady"] = String(value)
        commodity[itemEncoder(input: item)] = itemContent
        originalCommodities[orders[indexPath.section].orderID] = commodity
        let data = ["allOrder": commodity]
        
        updateOrderStatus(collectionView: collectionView, orderID: orders[indexPath.section].orderID, data: data)
        
        if orders[indexPath.section].itemsQty[indexPath.row] == 0 {
            orders[indexPath.section].items.remove(at: indexPath.row)
            orders[indexPath.section].itemsQty.remove(at: indexPath.row)
        }
        
        if orders[indexPath.section].items.count == 0 {
            orders.remove(at: indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 * animateDelay,
            animations: {
                cell.alpha = 1
        })
        animateDelay += 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Methods.
    func updateOrderStatus(collectionView: UICollectionView, orderID: String, data: [String: Any]) {
        firebaseCommunicator.updateData(collectionName: FIREBASE_COLLECTION_NAME, documentName: orderID, data: data) { (result, error) in
            if let error = error {
                print("update error: \(error)")
            } else {
                print("update successful.")
            }
        }
    }
    
    func itemEncoder(input: String) -> String{
        switch input {
        case "牛肉漢堡":
            return "BeefHamburger"
        case "雞肉漢堡":
            return "ChickenHamburger"
        case "豬肉漢堡":
            return "PorkHamburger"
        case "紅醬義大利麵":
            return "TomatoSpaghetti"
        case "青醬義大利麵":
            return "PestoSpaghetti"
        case "白醬義大利麵":
            return "CarbonaraSpaghetti"
        case "起司披薩":
            return "CheesePizza"
        case "番茄披薩":
            return "TomatoPizza"
        case "橄欖披薩":
            return "OlivaPizza"
        case "牛菲力":
            return "FiletMigon"
        case "牛肋排":
            return "RibeyeSteak"
        case "炙燒牛排":
            return "GrilledSteak"
        case "馬卡龍":
            return "Macaron"
        case "巧克力蛋糕":
            return "ChocolateCake"
        case "聖代":
            return "Sundae"
        default:
            return "unknown"
        }
    }
}
