//
//  AdminViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/11/6.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch let signOutErroe as NSError {
            print("Error signing out: %$", signOutErroe)
        }
    }
}
