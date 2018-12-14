//
//  InformationViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/13.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase
class InformationViewController: UIViewController {

    let fireBase = FirebaseCommunicator.shared
    var objects = [Information]()
    var information = Information()
    var loadinfo:[String:Any] = ["":1]
    
    
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadinfonum()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadinfonum()
    }
    func loadinfonum() {
        //下載
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid fail")
            return
        }
        fireBase.loadData(collectionName: "account", documentName: currentUserUid) { (result, error) in
            if let error = error {
                print("error: \(error)")
            }else{
                let result = result as! [String:Any]
                self.loadinfo = result
                print("loadinfo : \(self.loadinfo)")
                self.information.birthday = self.loadinfo["Birthday"] as? String ?? ""
                self.information.email = self.loadinfo["email"] as? String ?? ""
                self.information.phoneNum = self.loadinfo["PhoneNumber"] as? String ?? ""
                self.information.gender = self.loadinfo["Gender"] as? String ?? ""
                self.information.name = self.loadinfo["name"] as? String ?? ""
                
                self.email.text = self.information.email
                self.name.text = self.information.name
                self.birthday.text = self.information.birthday
                self.phone.text = self.information.phoneNum
                if self.information.gender == "1" {
                    self.gender.text = "Male"
                }else if self.information.gender == "2" {
                    self.gender.text  = "Female"
                }else{
                    self.gender.text = ""
                }
                
                self.objects.append(self.information)
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
