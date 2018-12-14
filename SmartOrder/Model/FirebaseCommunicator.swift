//
//  FirebaseCommunicator.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/15.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCommunicator {
    static let shared = FirebaseCommunicator()
    let db: Firestore!
    let storage: Storage!
    let storageRef: StorageReference!
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        storage = Storage.storage()
        storageRef = storage.reference(forURL: "gs://smartorder-ios.appspot.com/")
    }
    
    
    typealias DoneHandler = (_ results: Any?, _ errorCode: Error?) -> Void
    
    // 新增data.
    func addData(collectionName: String,
                 documentName: String?,
                 data: [String: Any],
                 overwrite: Bool = true,
                 completion: @escaping DoneHandler) {
        var finalData = data
        finalData.updateValue(FieldValue.serverTimestamp(), forKey: "timestamp")
        
        guard let documentName = documentName else {
            db.collection(collectionName).addDocument(data: finalData) { (error) in
                if let  error = error {
                    print("Add data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Add data successful.")
                    completion(true, nil)
                }
            }
            return
        }
        db.collection(collectionName).document(documentName).setData(finalData) { error in
            if let  error = error {
                print("Add data error: \(error).")
                completion(nil, error)
            } else {
                print("Add data successful.")
                completion(true, nil)
            }
        }
    }
    
    // 刪除documentName的Data.
    func deleteData(collectionName: String,
                    documentName: String,
                    completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).delete() { error in
            if let  error = error {
                print("Delete data error: \(error).")
                completion(nil, error)
            } else {
                print("Delete data successful.")
                completion(true, nil)
            }
        }
    }
    
    // 刪除documentName其中一筆Data.
    func deleteData(collectionName: String,
                    documentName: String,
                    data: String,
                    completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).updateData([data: FieldValue.delete()]) { error in
            if let  error = error {
                print("Delete data error: \(error).")
                completion(nil, error)
            } else {
                print("Delete data successful.")
                completion(true, nil)
            }
        }
    }
    
    // 修改data.
    func updateData(collectionName: String,
                    documentName: String,
                    data: [String: Any],
                    completion: @escaping DoneHandler) {
        let target = db.collection(collectionName).document(documentName)
        db.runTransaction({ (transaction, error) -> Any? in
            transaction.updateData(data, forDocument: target)
            return nil
        }) { (results, error) in
            if let error = error {
                print("Update data error: \(error).")
                completion(nil, error)
            } else {
                print("Update data successful.")
                completion(true, nil)
            }
        }
    }
    
    // 查詢collectionName內所有data.
    func loadData(collectionName: String,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Load data error: \(error).")
                completion(nil, error)
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                completion(results, error)
            }
        }
    }
    
    // 查詢documentName內所有data.
    func loadData(collectionName: String,
                  documentName: String,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).getDocument { (document, error) in
            if let error = error {
                print("Load data error: \(error).")
                completion(nil, error)
            } else if let document = document, document.exists {
                print("Load data: \(document.data()!)")
                completion(document.data(), nil)
            }
        }
    }
    
    // 查詢collectionName內所有符合condition的field之data.
    func loadData(collectionName: String,
                  field: String,
                  condition: Any,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).whereField(field, isEqualTo: condition).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Load data error: \(error).")
                completion(nil, error)
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                completion(results, nil)
            }
        }
    }
    
    // 查詢collectionName內所有符合時間範圍內之data.
    func loadData(collectionName: String,
                  greaterThanOrEqualTo start: String? = nil,
                  lessThanOrEqualTo end: String? = nil,
                  completion: @escaping DoneHandler) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        
        if let startTime = start, let endTime = end {
            let startDate = dateFormatter.date(from: startTime)
            let startTimestamp = Timestamp(date: startDate!)
            let endDate = dateFormatter.date(from: endTime)
            let endTimestamp = Timestamp(date: endDate!)
            
            db.collection(collectionName).whereField("timestamp", isGreaterThanOrEqualTo: startTimestamp).whereField("timestamp", isLessThanOrEqualTo: endTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
        
        if let startTime = start, end == nil {
            let startDate = dateFormatter.date(from: startTime)
            let startTimestamp = Timestamp(date: startDate!)
            db.collection(collectionName).whereField("timestamp", isGreaterThanOrEqualTo: startTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
        
        if start == nil, let endTime = end {
            let endDate = dateFormatter.date(from: endTime)
            let endTimestamp = Timestamp(date: endDate!)
            
            db.collection(collectionName).whereField("timestamp", isLessThanOrEqualTo: endTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
    }
    
    //上傳大頭照
    func sendPhoto(selectedImageFromPicker: UIImage?, uniqueString: String){
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        //let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storage = Storage.storage()
            let storageRef = storage.reference().child("AppCodaFireUpload").child("\(uniqueString).jpeg")
            
            if let uploadData = selectedImage.jpegData(compressionQuality: 1.0) {
                // 這行就是 FirebaseStorage 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {
                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        print("Photo Url: \(url!)")
                    }
                    
                    
                })
            }
        }
    }
    
    
    // 下載圖片.
    func downloadImage(url: String,
                       fileName: String,
                       isUpdateToLocal: Bool = false,
                       competion: @escaping DoneHandler) {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageURL = url + fileName
        let localImageURL = cacheURL.appendingPathComponent(imageURL)
        print("localImageURL: \(localImageURL)")
        
        // 從本機Cache取得圖片.
        if let data = try? Data(contentsOf: localImageURL), !isUpdateToLocal {
            print("getData from local successful.")
            let image = UIImage(data: data)
            competion(image, nil)
        } else {    // 本機無資料, 網路下載.
            print("readData from local fail.")
            
            let islandRef = storageRef.child(imageURL)
            
            islandRef.write(toFile: localImageURL) { (url, error) in
                if let error = error {
                    print("getData error: \(error)")
                    competion(nil, error)
                } else {
                    print("getData from internet successful.")
                    if let data = try? Data(contentsOf: url!) {
                        let image = UIImage(data: data)
                        competion(image, nil)
                    } else {
                        print("readData from local error.")
                    }
                    
                }
            }
        }
    }
}
