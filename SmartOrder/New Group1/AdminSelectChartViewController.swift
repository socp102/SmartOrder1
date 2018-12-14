//
//  AdminSelectChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/11/26.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts
import Firebase



class AdminSelectChartViewController: UIViewController {

    @IBOutlet weak var datePickerValue: UIDatePicker!
    @IBOutlet weak var pickSetView: UIView!
    @IBOutlet weak var timeTypeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var selectChartSegmented: UISegmentedControl!
    @IBOutlet weak var selectTypeSegmented: UISegmentedControl!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var startTime = ""
    var endTime = ""
    
    // 圖表資料 Chart Data
    var commodityCountData: [String: Int] = [:]  // 商品數量加總
    var commoditySubtotalData: [String: Int] = [:]   // 商品小記加總
    var totalDayData: [String: Int] = [:]   // 日營收
    var totalMonthData: [String: Int] = [:] // 月營收
    var peopleDayData: [String: Int] = [:]  // 日來客
    var peopleMonthData: [String: Int] = [:] // 月來客
    
    var firebaseCommunicator = FirebaseCommunicator.shared  //firebase common用
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DatePick日期限制
        datePickerValue.maximumDate = Date()
    }
    
    // 關閉DatePick畫面
    @IBAction func cancelPickViewBtn(_ sender: Any) {
        pickViewChange()
        timeTypeLabel.text = "" // 清空DatePick title
    }
    
    // Date Pick Chack Botton 時間確認 and 起始小於結束檢查
    @IBAction func chackDateTimeBtn(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePickerValue.date)
        print("\(dateString) set")
        
        // Title.Lable檢查
        if let timeSetType = timeTypeLabel.text {
            switch timeSetType {
            case "Start Time Set":
                if endTime != "" {
                    if formatter.date(from: endTime)! <
                        formatter.date(from: dateString)! {
                        dateAlert(Message: "起始時間不得小於結束時間")
                        print("xxx time error")
                        return
                    }
                }
                startLabel.text = dateString // 起始label
                timeTypeLabel.text = ""      // pickerTital 清空
                startTime = dateString       // 起始時間
            case "End Time Set":
                if startTime != "" {
                    if formatter.date(from: startTime)! >
                        formatter.date(from: dateString)! {
                        dateAlert(Message: "起始時間不得小於結束時間")
                        print("xxx time error")
                        return
                    }
                }
                endLabel.text = dateString
                timeTypeLabel.text = ""
                endTime = dateString
            default:
                break
            }
            pickViewChange()    // 關閉PickView
        }
    }
    
    // StartTime設定Btn
    @IBAction func startTimeSetBtn(_ sender: UIButton) {
        pickViewChange()
        
        timeTypeLabel.text = "Start Time Set"
//        if pickSetView.isHidden == false {
//            timeTypeLabel.text = ""
//        }
    }
    // EndTime設定Btn
    @IBAction func endTimeSetBtn(_ sender: UIButton) {
        pickViewChange()
        timeTypeLabel.text = "End Time Set"
//        if pickSetView.isHidden == false {
//            timeTypeLabel.text = ""
//        }
    }
    
    // DatePickView 畫面收放
    func pickViewChange () {
        if pickSetView.isHidden == true {
            pickSetView.isHidden = false
        } else {
            pickSetView.isHidden = true
        }
    }
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch let signOutErroe as NSError {
            print("Error signing out: %$", signOutErroe)
        }
    }
    
    // 繪圖鈕 Chart Button
    @IBAction func chartStartBtn(_ sender: UIButton) {
        // 設定檢查
        if startTime == "" || endTime == "" || selectTypeSegmented.selectedSegmentIndex == -1 ||
            selectChartSegmented.selectedSegmentIndex == -1 {
            dateAlert(Message: "時間或設定未選取")
            return
        }
        loadingView.startAnimating()
        testDataBtn()
        // 延遲
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.chartStart()
            self.loadingView.stopAnimating()
        }
        
    }
    
    // Chart 頁面入口選擇
     func chartStart() {
        
        var chartType: String = ""
        switch selectChartSegmented.selectedSegmentIndex {
        case 1:
            chartType = "BarChartVC"
        case 2:
            chartType = "PieChartVC"
        default:
            chartType = "LineChartVC"
        }
        if chartType != "" {
            performSegue(
                withIdentifier: chartType, sender: nil)
        } else {
            print("performSegue Error")
        }
    }
    
    // 換頁帶資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
            
        case "LineChartVC":  // 折線圖
            if selectTypeSegmented.selectedSegmentIndex == 0 {
                let controller = segue.destination as! AdminLineChartViewController
                controller.chartDataA = totalDayData
                controller.chartDataB = totalMonthData
                controller.type = ["日收入", "月收入"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            } else {
                let controller = segue.destination as! AdminLineChartViewController
                controller.chartDataA = peopleDayData
                controller.chartDataB = peopleMonthData
                controller.type = ["日來客", "月來客"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            }
//            print("prepare LineChartVC")
        case "BarChartVC":  // 長條圖
            switch selectTypeSegmented.selectedSegmentIndex {
            case 0:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataA = totalDayData
                controller.chartDataB = totalMonthData
                controller.type = ["日收入", "月收入"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            case 1:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataA = peopleDayData
                controller.chartDataB = peopleMonthData
                controller.type = ["日來客", "月來客"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            case 2:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataA = commodityCountData
                controller.chartDataB = commoditySubtotalData
                controller.type = ["商品售出量", "商品銷售額"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            default:
                print("selectTypeSegmented Error")
                break
            }
//            print("prepare BarChartVC")
            
        case "PieChartVC":  // 圓餅圖
            
                let controller = segue.destination as! AdminPieChartViewController
                controller.chartDataA = commodityCountData
                controller.timePart = "\(startTime) ~ \(endTime)"
                controller.type = ["商品售出量", "銷售量前五"]

//            print("prepare PieChartVC")
            
        default:
            print("prepare Error")
        }
    }
    
    
    // \(endLabel.text) 資料取得 包裝
     func testDataBtn() {
        let addStartTime = startTime + " 00:00:00"
        let addEndTime = endTime + " 23:59:59"
        print("time Start \(addStartTime)\nEnd \(addEndTime)")
        
        firebaseCommunicator.loadData(collectionName: "order", greaterThanOrEqualTo: addStartTime, lessThanOrEqualTo: addEndTime) { (results, error) in
            if let error = error {
                print("error \(error)")
            } else {
                print("results ttt \(results!)")
                
                var count: Int = 0
                var name: String = ""
                var subtotal: Int = 0
                
                // 資料拆解
                let t1 = results as! Dictionary<String, Any>
                for (_, v1) in t1 {
                    
                    var total: Int = 0

                    var timestamp = Timestamp ()
                    let commodity = [ProductModel] ()
                    var pack = FireOrderData(commodity: commodity, timestamp: timestamp, total: total)
                    
                    let t2 = v1 as! Dictionary<String, Any>
                    for (k2, v2) in t2 {
                        
                        switch k2 {
                        case "allOrder":
                            let t3 = v2 as! Dictionary<String, Any>
                            for (k3, v3) in t3 {    // 商品層
                                name = k3    // add
                                let t4 = v3 as! Dictionary<String, Any>
                                for (k4, v4) in t4 {    // 商品內層資料
                                    if k4 == "count" {
                                        count = Int(v4 as! String)!  // add
                                    }
                                    if k4 == "subtotal" {
                                        subtotal = Int(v4 as! String)!   // add
                                    }
                                }
                                // 組成物件
                                let product = ProductModel(name: name, count: count, subtotal: subtotal)
                                pack.commodity.append(product)
                                // 清空
                                name = ""
                                count = 0
                                subtotal = 0
//                                print("product \(product)")
                            }
                        case "timestamp":
                            timestamp = v2 as! Timestamp
                        case "total":
                            total = Int(v2 as! String)!
                        default:
//                            print("Default not use \(v2)")
                            break
                        }
                    }
                    pack.timestamp = timestamp
                    pack.total = total
                    
                    
                    print("pack \(pack)")
                    self.dataOperation(data: pack)  // 呼叫方法
                    
                }
            }
        }
    }
    
    // Chart選擇 & 鎖定 (設定項
    @IBAction func selectTypeBtn(_ sender: UISegmentedControl) {
        switch selectTypeSegmented.selectedSegmentIndex {
        case 0:
            selectChartSegmented.setEnabled(true, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(false, forSegmentAt: 2)
            
        case 1:
            selectChartSegmented.setEnabled(true, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(false, forSegmentAt: 2)
            
        case 2:
            selectChartSegmented.setEnabled(false, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(true, forSegmentAt: 2)
            
        default:
            print("selectType Error")
        }
    }
    
    func dateAlert (Message: String) {
        let alertController = UIAlertController(
            title: "提示",
            message: Message,
            preferredStyle: .actionSheet)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                print("按下確認後的動作")
        })
        alertController.addAction(okAction)
        // 顯示提示框
        present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
}


extension AdminSelectChartViewController {
    
    // 資料處理
    func dataOperation (data: FireOrderData) {
        
        for i in data.commodity {
            
            let a = commodityCountData[i.name]
            let b = commoditySubtotalData[i.name]
            // 商品與商品售出量
            // 取得出值就加總 不存在就創造
            if a != nil {
                commodityCountData[i.name] = i.count + a!
            } else {
                commodityCountData[i.name] = i.count
            }
            // 商品售出額
            if b != nil {
                commoditySubtotalData[i.name] = i.subtotal + b!
            } else {
                commoditySubtotalData[i.name] = i.subtotal
            }
        }
        
        // 營收 income / 日 day & 來客數
        let day = timestampInString(timestamp: data.timestamp, type: "day")
        let d = totalDayData[day]
        let pd = peopleDayData[day]
        if (d != nil) || pd != nil {
            totalDayData[day] = data.total + d! // 存在則加總    // 營收
            peopleDayData[day] = pd! + 1        // 存在加1 // 來客
        } else {
            totalDayData[day] = data.total      // 不存在新增
            peopleDayData[day] = 1              // 不存在給值
        }
        
        // 營收 income / 月 month & 來客數
        let month = timestampInString(timestamp: data.timestamp, type: "month")
        let m = totalMonthData[month]
        let pm = peopleMonthData[month]
        if (m != nil), pm != nil {
            totalMonthData[month] = data.total + m!
            peopleMonthData[month] = pm! + 1

        } else {
            totalMonthData[month] = data.total
            peopleMonthData[month] = 1
        }
        
    }
    
    // 時間轉換 Time Change
    func timestampInString (timestamp : Timestamp, type: String) -> String {
        
        var tempTime: String = ""
        let time: Double = Double(timestamp.seconds)
        // 轉換時間
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 格式化輸出
        let dformatter = DateFormatter()
        
        switch type {
        case "month":
            dformatter.dateFormat = "yyyy/MM"
            tempTime = dformatter.string(from: date)
        case "day":
            dformatter.dateFormat = "MM/dd"
            tempTime = dformatter.string(from: date)
        default:
            assertionFailure("Strint Type Error")
        }
        return tempTime
    }
    
}




