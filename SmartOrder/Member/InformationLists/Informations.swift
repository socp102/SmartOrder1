//
//  Informations.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

struct Information {
    var name = ""
    var gender = ""
    var phoneNum = ""
    var email = ""
    var birthday = ""
}

class New{
    let fireBase = FirebaseCommunicator.shared
    func new() {
        
        guard let currentUserUid = Auth.auth().currentUser else {
            print("uid fail")
            return
        }
        var mail = currentUserUid.email
        var name = currentUserUid.displayName
        var phone = currentUserUid.phoneNumber
        print ("mail: \(mail),name:\(name),phone:\(phone)")
        fireBase.loadData(collectionName: "account") { (result, error) in
            if let error = error {
                print("error:\(error)")
            } else {
                let results = result as! [String:Any]
                let hascount = results.keys.contains(currentUserUid.uid)
                
                if hascount == true {
                } else {
                    if mail != nil || name != nil || phone != "" {
                        let datas = ["email":mail,"name":name,"PhoneNumber":phone,"Gender":"","Birthday":""]
                        self.fireBase.addData(collectionName: "account", documentName: currentUserUid.uid, data: datas as [String : Any]) { (result, error) in
                            if let error = error {
                                print("error:\(error)")
                            }
                            print("account: \(result!)")
                        }
                    } else {
                        mail = ""
                        name = ""
                        phone = ""
                        let datas = ["email":mail,"name":name,"PhoneNumber":phone,"Gender":"","Birthday":""]
                        self.fireBase.addData(collectionName: "account", documentName: currentUserUid.uid, data: datas as [String : Any]) { (result, error) in
                            if let error = error {
                                print("error:\(error)")
                            }
                            print("account: \(result!)")
                        }
                    }
                    
                }
            }
            
        }
    }
    

}
