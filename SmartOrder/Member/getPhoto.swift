//
//  getPhoto.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

class Getphoto {
    let communicator = FirebaseCommunicator.shared
    
    let currentUserUid = Auth.auth().currentUser
    
    func showname()->String{
        var currentUsername = Auth.auth().currentUser?.email
        if currentUserUid?.displayName != "" {
            currentUsername = currentUserUid?.displayName
        }
        
        return currentUsername!
    }
    
    func update() -> UIImage{
        var pho = UIImage(named: "camera")
        guard let currentUserUid = Auth.auth().currentUser else {
            print("currentUserUid is nil")
            return pho!
        }
        //下載照片
        communicator.downloadImage(url: "AppCodaFireUpload/", fileName: "\(currentUserUid.uid).jpeg") { (result, error) in
            if let error = error {
                print("download photo error:\(error)")
                
            } else {
                pho = (result as! UIImage)
            }
            
        }
        return pho!
    }
    
    
}
