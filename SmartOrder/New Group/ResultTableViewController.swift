//
//  ResultTableViewController.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/20.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit
import Firebase

class ResultTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let myUserDefaults = UserDefaults.standard
    var addDict =  [String: [String:String]]()
    @IBOutlet weak var totalPriceLabel: UILabel!
    var firebaseCommunicator = FirebaseCommunicator.shared
    let user = Auth.auth().currentUser?.uid
    
    @IBAction func resultCloseBtn(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet weak var sendToFirebaseOutlet: UIButton!
    
    @IBAction func sendOrderToFirebase(_ sender: Any) {
        
        let alert = UIAlertController(title: "確認", message: "送出後可在會員頁面查看", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "發送", style: .default) {
            UIAlertAction in
            
            let food = self.addDict as [String:Any]
            var foodData = [ "allOrder" : food] as [String : Any]
            foodData["total"] = self.getTotal()
            foodData["userID"] = self.user
            

            if self.couponUserSelectDiscount > 0 {
                
                foodData["coupon"] = "\(self.resultTitle) , \(self.couponUserSelectDiscount)"
                foodData["total"] = self.withCouponResultPrice
                
                self.firebaseCommunicator.addData(collectionName: "order", documentName: nil, data: foodData) { (result, error) in
                    if let error = error {
                        
                        print("error:\(error)")
                    }
                    
                }
                
            } else {
                
                self.firebaseCommunicator.addData(collectionName: "order", documentName: nil, data: foodData) { (result, error) in
                    if let error = error {
                        
                        print("error:\(error)")
                    }
                }
                
            }
            
            self.myUserDefaults.removeObject(forKey: "resultDict")
            self.addDict.removeAll()
            self.tableView.reloadData()
            self.totalPriceLabel.text = "0"
            self.showCouponBtnOutlet.setTitle("選購優惠卷", for: .normal)
            self.checkAddDict()
            self.discountOutlet.isHidden = true
        
        }
        
        let cancelAction = UIAlertAction(title: "取消", style:.cancel) {
            UIAlertAction in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present (alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 如果使用者預設有資料的話，就把資料匯入到addDict字典
        if myUserDefaults.value(forKey: "resultDict") != nil {
        
            addDict = (myUserDefaults.object(forKey: "resultDict") as? [String: [String:String]])!
            
        }
        
        
        
        if myUserDefaults.value(forKey: "resultTitle") != nil {
            
            resultTitle = myUserDefaults.object(forKey: "resultTitle") as! String
            showCouponBtnOutlet.setTitle(resultTitle, for: .normal)
            discountOutlet.isHidden = false
        }
        
        if myUserDefaults.value(forKey: "couponUserSelectDiscount") != nil {
            
            couponUserSelectDiscount = myUserDefaults.object(forKey: "couponUserSelectDiscount") as! Double

        }
        

        checkAddDict()  //addDict 沒資料的話按鍵設為false
        totalPriceLabel.text = getTotal()
        getCouponInfo()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return addDict.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        

        let userAddedItem = Array(addDict.keys)
        
        let dictEngAndChinese = ["BeefHamburger": "牛肉漢堡", "ChickenHamburger": "雞肉漢堡", "PorkHamburger": "豬肉漢堡",
                                 "TomatoSpaghetti": "紅醬義大利麵", "PestoSpaghetti": "青醬義大利麵", "CarbonaraSpaghetti": "白醬義大利麵",
                                 "CheesePizza": "起司披薩", "TomatoPizza": "番茄披薩", "OlivaPizza": "橄欖披薩",
                                 "FiletMigon":"牛菲力", "RibeyeSteak": "牛肋排", "GrilledSteak":"炙燒牛排",
                                 "Macaron":"馬卡龍", "ChocolateCake": "巧克力蛋糕", "Sundae": "聖代"]
        
//      檢視使用者所加入的所有項目userAddedItem[BeefHamburger,ChickenHamburger,PorkHamburger]
//      例如抓到的第一個項目為BeefHamburger，就用dictEngAndChinese字典查，去尋找dictEngAndChinese[BeefHamburger]值為"牛肉漢堡"，並存在result陣列裡
        let result = userAddedItem.map { englishName in
            dictEngAndChinese[englishName] ?? englishName
        }
        
        cell.resultName?.text =  result[indexPath.row]
        cell.resultCount?.text =  Array(addDict.values)[indexPath.row]["count"]
        cell.resultSubtotal?.text = Array(addDict.values)[indexPath.row]["subtotal"]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let index = indexPath.row  //現在按的索引值
            var addDictKey = Array(addDict.keys)  // 把key全部取出來，放到陣列
            let key  = addDictKey[index]   // 抓到的索引值為陣列相對應的key


            if let idx = addDict.index(forKey: key) {
                addDict.remove(at: idx)

                let object = myUserDefaults.object(forKey: "resultDict") as! NSDictionary  // 把userDefaults的資料轉成NSDictionary
                let storedValue = NSMutableDictionary.init(dictionary:object)
                storedValue.removeObject(forKey: key)

                myUserDefaults.set(storedValue, forKey: "resultDict")
                myUserDefaults.synchronize()

                let newObject : NSMutableDictionary = myUserDefaults.object(forKey: "resultDict") as! NSMutableDictionary //
                print(newObject)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                totalPriceLabel.text = getTotal()
                }
            
            checkAddDict()

            }
        }
    
    
    func getTotal () -> String {
        
        let dictValues = addDict.values
        let subtotalString = dictValues.map { $0["subtotal"] }
        let subtotalDouble = subtotalString.compactMap { Double($0!) }
        let sum = subtotalDouble.reduce(0, +)
        var sumString = String(sum)
        
        
        if couponUserSelectDiscount > 0 {

            
            if couponUserSelectDiscount > 1 {
                
                let withCouponPriceDouble = sum - couponUserSelectDiscount
                let withCouponPriceInt = Int(withCouponPriceDouble)
                let withCouponPriceString = String(withCouponPriceInt)
                sumString = withCouponPriceString
                
            }else {
                
                let withCouponPriceDouble = sum * couponUserSelectDiscount
                let withCouponPriceInt = Int(withCouponPriceDouble)
                let withCouponPriceString = String(withCouponPriceInt)
                sumString = withCouponPriceString
                
            }
            
        } else {
            
            let sumInt = Int(sum)
            sumString = String(sumInt)
        }
        
        return sumString
        
    }
    
    func getCouponInfo() {
        //抓優惠卷資料
        firebaseCommunicator.loadData(collectionName: "couponInfo") { (result, error) in
            if let error = error {
                print("error:\(error)")
            } else {
                
                self.couponInfo = result as! [String:[String:Any]]
                
                let couponCollection = ["001","002","003"]

                for reviewCoupon in  couponCollection {
                    
                    var couponReview = self.couponInfo["\(reviewCoupon)"]
                    let couponOwner = couponReview?["owner"]
                    let couponOwnerNSDictionary = couponOwner as? NSDictionary
                    let couponDictionaryOptional = couponOwnerNSDictionary as? Dictionary<String, Any>
                    let couponOwnerDictionary = couponDictionaryOptional!
                    
                    let hasCoupon = couponOwnerDictionary.keys.contains(self.user!)
                    
                    //使用者有在該優惠卷裡面
                    if hasCoupon == true   {
                        
                       let userCouponValueAny = couponOwnerDictionary[self.user!]
                        let userCouponValueInt = userCouponValueAny as! Int
                        
                        //領取但還沒用過
                        if userCouponValueInt == 0 {
                            
                            
                        //領取但已使用過
                        }else if userCouponValueInt == 1 {
                            
                            self.couponInfo.removeValue(forKey: "\(reviewCoupon)")

                        }
                        
                    } else if hasCoupon == false  {
                        
                        self.couponInfo.removeValue(forKey: "\(reviewCoupon)")
                        
                        }
                    }
                
                }
            }
        }
    
    var couponInfo:[String:[String:Any]] = [:]
    var couponUserSelectDiscount : Double = 0.0
    var couponUserCombo :[String:Double] = [:]
    var withCouponResultPrice:String = ""
    var resultTitle = ""
    
    @IBOutlet weak var showCouponBtnOutlet: UIButton!
    @IBOutlet weak var discountOutlet: UILabel!
    var couponPickerView: UIPickerView = UIPickerView()
    
    @IBAction func showCouponBtnAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "請選擇優惠卷", message: "基於使用期限，請儘速使用完畢", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) {
            UIAlertAction in
            
            //確認後更改總金額，所以要先抓到使用者選到的是哪一項優惠內容
            let removeFloating = Int(self.getTotal())!
            self.withCouponResultPrice = String(removeFloating)
            self.totalPriceLabel.text = self.withCouponResultPrice
            self.discountOutlet.isHidden = false
            
            self.myUserDefaults.setValue(self.resultTitle, forKey: "resultTitle")
            self.myUserDefaults.setValue(self.couponUserSelectDiscount, forKey: "couponUserSelectDiscount")
        
        }
        
        let cancelAction = UIAlertAction(title: "取消", style:.cancel) {
            UIAlertAction in
            
            self.couponUserSelectDiscount = 0
            self.showCouponBtnOutlet.setTitle("選購優惠卷", for: .normal)
            self.totalPriceLabel.text = self.getTotal()
            self.discountOutlet.isHidden = true
            
            self.myUserDefaults.removeObject(forKey: "resultTitle")
            self.myUserDefaults.removeObject(forKey: "couponUserSelectDiscount")

            

        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        let containerViewWidth = 250
        let containerViewHeight = 120
        let containerFrame = CGRect(x:10, y: 70, width: CGFloat(containerViewWidth), height: CGFloat(containerViewHeight))
        couponPickerView = UIPickerView(frame: containerFrame)
        couponPickerView.delegate = self
        couponPickerView.dataSource = self
        
        couponPickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(couponPickerView, didSelectRow: 0, inComponent: 0)
        
        alert.view.addSubview(couponPickerView)
        
        // now add some constraints to make sure that the alert resizes itself
        let cons:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: couponPickerView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.00, constant: 130)
        
        alert.view.addConstraint(cons)
        
        let cons2:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: couponPickerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.00, constant: 20)
        
        alert.view.addConstraint(cons2)
        
        // present with our view controller
        present(alert, animated: true, completion: nil)

        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return couponInfo.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            let index =  row
            var couponInfoValue = Array(couponInfo.values)
            let key  = couponInfoValue[index]
            let result = key["couponTitle"] as! String
            return result
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            let index =  row
            var couponInfoValue = Array(couponInfo.values)
            
            if couponInfo.count == 0 {
                
                
            } else {
                
                let key  = couponInfoValue[index]
                resultTitle = key["couponTitle"] as! String
                showCouponBtnOutlet.setTitle(resultTitle, for: .normal)
                
                let resultDiscount = key["couponDiscount"] as! Double
                couponUserSelectDiscount = resultDiscount
                couponUserCombo = [resultTitle:couponUserSelectDiscount]
                
            }
    }
    
    func checkAddDict() {
        
        if addDict.count == 0 {
            
            sendToFirebaseOutlet.isEnabled = false
            sendToFirebaseOutlet.setTitle("尚未選購", for: .normal)
            sendToFirebaseOutlet.setTitleColor(.white, for: .normal)

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "orderToDetail"{
        
            if let tableViewIndex = tableView.indexPathForSelectedRow {
                
               let detailController = segue.destination as! DetailTableViewController
               let itemName = Array(addDict.keys)
               let result = itemName[tableViewIndex.row]
                
                switch result {
                    
                case "BeefHamburger":
                    detailController.menuSelectedNumber = 0
                    detailController.detailImageNumber = 0
                    
                case "ChickenHamburger":
                    detailController.menuSelectedNumber = 0
                    detailController.detailImageNumber = 1
                    
                case "PorkHamburger":
                    detailController.menuSelectedNumber = 0
                    detailController.detailImageNumber = 2
                    
                case "TomatoSpaghetti":
                    detailController.menuSelectedNumber = 1
                    detailController.detailImageNumber = 0
                    
                case "PestoSpaghetti":
                    detailController.menuSelectedNumber = 1
                    detailController.detailImageNumber = 1
                    
                case "CarbonaraSpaghetti":
                    detailController.menuSelectedNumber = 1
                    detailController.detailImageNumber = 2
                    
                case "CheesePizza":
                    detailController.menuSelectedNumber = 2
                    detailController.detailImageNumber = 0
                    
                case "TomatoPizza":
                    detailController.menuSelectedNumber = 2
                    detailController.detailImageNumber = 1
                    
                case "OlivaPizza":
                    detailController.menuSelectedNumber = 2
                    detailController.detailImageNumber = 2
                    
                case "FiletMigon":
                    detailController.menuSelectedNumber = 3
                    detailController.detailImageNumber = 0
                    
                case "RibeyeSteak":
                    detailController.menuSelectedNumber = 3
                    detailController.detailImageNumber = 1
                    
                case "GrilledSteak":
                    detailController.menuSelectedNumber = 3
                    detailController.detailImageNumber = 2
                    
                case "Macaron":
                    detailController.menuSelectedNumber = 4
                    detailController.detailImageNumber = 0
                    
                case "ChocolateCake":
                    detailController.menuSelectedNumber = 4
                    detailController.detailImageNumber = 1
                    
                case "Sundae":
                    detailController.menuSelectedNumber = 4
                    detailController.detailImageNumber = 2
                    
                default:
                    break
                }
                
            }
            
       }
    }
    
}
