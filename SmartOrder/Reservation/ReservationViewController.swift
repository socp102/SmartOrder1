//
//  ReservationViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications

class ReservationViewController: UIViewController , CLLocationManagerDelegate{
    @IBOutlet weak var getNumberButton: UIButton!
    @IBOutlet weak var cancelNumberBtuuon: UIButton!
    
    @IBOutlet weak var displayNumber: UILabel!
    @IBOutlet weak var myNumber: UILabel!
    
//    let beaconUUID0 = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935") // 預設備用
    let beaconUUID1 = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF055555")
    let manager = CLLocationManager()
    var beaconRegion: CLBeaconRegion!
    
    let userDefaults = UserDefaults.standard
    var db: Firestore!
    var ref: CollectionReference!
    var listener: ListenerRegistration!
    
    var today = ""
    var userEmail = ""
    var documentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // 取得今天日期轉字串
        let now = Date()
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let today = dateFormat.string(from: now)
        // 存取路徑定義
        ref = db.collection("Reservation").document("Waiting").collection(today)
        // 取得登入帳號
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        userEmail = email
        
        listenNumber() // 監聽跳號
        
        // ibbeacon
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID1!, identifier: "SmartOrder")
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 取消監聽器
        if let listener = listener {
            listener.remove()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 檢查是否已經取號
        if userDefaults.string(forKey: "documentID") == nil {
            changeButton(getNumber: true)
        } else {
            changeButton(getNumber: false)
            myNumber.text = userDefaults.string(forKey: "MyNumber")
        }
    }
    
    @IBAction func getNumber(_ sender: Any) {
        getNumberButton.isUserInteractionEnabled = false
        getNumberButton.alpha = 0.3
        registration()
        manager.startMonitoring(for: beaconRegion)
    }
    
    @IBAction func testNumber(_ sender: Any) { // 取消候位按鈕
        cancelWaiting()
        manager.stopMonitoring(for: beaconRegion)
        manager.stopRangingBeacons(in: beaconRegion)
    }
    // 監聽目前號碼
    func listenNumber() {
        
        listener = ref.document("Number").addSnapshotListener(includeMetadataChanges: true) { (snapshot, err) in
            if let err = err {
                print("Fail to addSnapshotListener (監聽號碼失敗)\(err)")
            }
            guard let snapshot = snapshot else {
                print("snapshot is nil")
                self.setNumber()
                return
            }
            guard let dict = snapshot.data() else {
                print("snapshot.data() is nil")
                self.setNumber()
                return
            }
            self.displayNumber.text = dict["Number"] as? String
            print(dict["Number"] as! String)
        }
    }
    
    // 監聽號碼為空時設定為將號碼設定為0，並重新啟動監聽
    func setNumber() {
        ref.document("Number").setData(["Number" : "0"], merge: true) { (error) in
            if let error = error {
                print("Fail to setNumber(號碼設0失敗)\(error)")
                return
            }
            self.listenNumber()
        }
    }
    
    // 登記準備取號碼牌
    func registration() {
        let data = ["User": userEmail,
                    "Status": true,
                    "LocationState" : "inside",
                    "Timestamp":FieldValue.serverTimestamp()] as [String : Any]
        var docRef: DocumentReference? = nil
        docRef = ref.addDocument(data: data) { (err) in
            if let  err = err {
                print("Error writing document(寫入檔案錯誤): \(err)")
            } else {
                print("Document successfully written!(檔案成功寫入)")
                // 記錄檔案ID
                guard let documentID = docRef?.documentID else {
                    print("documentID is nil")
                    return
                }
                self.userDefaults.set(documentID, forKey: "documentID")
                self.getTimestamp()
            }
        }
    }
    
    // 取得登記的時間戳
    func getTimestamp() {
        if let documentID = userDefaults.string(forKey: "documentID") {
            ref.document(documentID).getDocument { (document, err) in
                if let myTimestamp = document?.data()?["Timestamp"], document!.exists {
                    print("myTimestamp:(取得時間戳) \(myTimestamp)")
                    self.getMyNumber(myTimestamp: myTimestamp)
                } else {
                    print("Document does not exist(時間戳檔案不存在)")
                }
            }
        }
    }
    
    // 顯示號碼(目前號碼，取得號碼)
    func getMyNumber(myTimestamp: Any) {
        let responds = ref.whereField("Timestamp", isLessThanOrEqualTo: myTimestamp)
        responds.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Load data error: \(error).")
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                print("getMyNumber：\(results.count)")
                self.myNumber.text = "\(results.count)"
                self.saveNumber(number: results.count)
            }
        }
    }
    
    func saveNumber(number: Int) {
        if let documentID = userDefaults.string(forKey: "documentID") {
            ref.document(documentID).setData(["MyNumber" : number], merge: true) { (err) in
                if let err = err {
                    print("Fail to saveNumber (保存號碼失敗)\(err)")
                } else {
                    self.changeButton(getNumber: false)
                    self.userDefaults.set(number, forKey: "MyNumber")
                    print("保存userDefaults  Number  = \(number)")
                }
            }
        }
    }
    
    func saveLocation(state: String) {
        if let documentID = userDefaults.string(forKey: "documentID") {
            ref.document(documentID).setData(["LocationState" : state], merge: true) { (err) in
                if let err = err {
                    print("Fail to saveNumber (保存位置狀態失敗)\(err)")
                } else {
                    self.changeButton(getNumber: false)
                    print("Change Location state to firebase= \(state)")
                }
            }
        }
    }
    
    // 取消候位
    func cancelWaiting() {
        if let documentID = userDefaults.string(forKey: "documentID") {
            changeButton(getNumber: true)
            self.myNumber.text = "0"
            userDefaults.set(nil, forKey: "documentID")
            ref.document(documentID).setData(["Status" : false], merge: true) { (err) in
                if let err = err {
                    print("Fail to cancelWaiting (取消候位失敗)\(err)")
                }
            }
        }
    }
    
    // 切換Button狀態
    func changeButton(getNumber: Bool) {
        getNumberButton.isUserInteractionEnabled = getNumber
        cancelNumberBtuuon.isUserInteractionEnabled = !getNumber
        if getNumber {
            getNumberButton.alpha = 1
            cancelNumberBtuuon.alpha = 0.3
        } else {
            getNumberButton.alpha = 0.3
            cancelNumberBtuuon.alpha = 1
        }
    }
    
    
    //MARK: -時間轉換時間戳
    func timeToTimeStamp(time: String) -> Timestamp {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let last = dfmatter.date(from: time)
        let timeStamp = Timestamp(date: last!)
        
        print("時間戳＝\(timeStamp)")
        return timeStamp
    }
    
    // 推播提醒
    func showNotification(_ message: String) {
        if UIApplication.shared.applicationState == .active {
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
            
        } else { // Background
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "iBeacon state changed."
            content.body = message
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            
            let request = UNNotificationRequest(identifier: "Alert", content: content, trigger: trigger)
            center.add(request) { (error) in
                // Add OK or error? ...
            }
            
        }
    }
    
    // MARK: - CLLocationManagerDelegate menthods.
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            showNotification("目前在現場候位中!")
            self.saveLocation(state: "inside")
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            
        } else { // .outside
            showNotification("已離開現場等候，到號時將自動過號!")
            self.saveLocation(state: "outside")
            manager.stopRangingBeacons(in: region as! CLBeaconRegion)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            let proximity: String
            switch beacon.proximity {
            case .unknown:
                proximity = "Unknown"
            case .immediate:
                proximity = "Immediate"
            case .near:
                proximity = "Near"
            case .far:
                proximity = "Far"
            }
            // infoLabel.text = "\(region.identifier),\(proximity),\(beacon.rssi),\(beacon.accuracy)"
        }
    }

}
