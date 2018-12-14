//
//  ViewController.swift
//  SmartOder
//
//  Created by kimbely on 2018/11/23.
//  Copyright © 2018 kimbely. All rights reserved.
//

import UIKit
import Firebase

class MemberViewController: UIViewController {
    
    let communicator = FirebaseCommunicator.shared
    let get = Getphoto()
    let newaccount = New()
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch let signOutErroe as NSError {
            print("Error signing out: %$", signOutErroe)
        }
    
    }
    
    @IBAction func MembersegmentAction(_ sender: UISegmentedControl) {
        switch MembersegmentedControl.selectedSegmentIndex {
        case 0:
            OrderlistView.isHidden = false
            CouponView.isHidden = true
            
            
        case 1:
            OrderlistView.isHidden = true
            CouponView.isHidden = false
            
        default:
            break
        }
    }
    @IBOutlet weak var MembersegmentedControl: UISegmentedControl!
    @IBOutlet weak var CouponView: UIView!
    @IBOutlet weak var OrderlistView: UIView!
    @IBOutlet weak var Photos: UIImageView!
    @IBOutlet weak var Id: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderlistView.isHidden = false
        CouponView.isHidden = true
        Photos.image = get.update()
        newaccount.new()
        Id.text = get.showname()
    }
    
}

