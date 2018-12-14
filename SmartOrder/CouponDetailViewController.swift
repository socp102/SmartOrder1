//
//  CouponDetailViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/12/2.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class CouponDetailViewController: UIViewController {
    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var couponTitle: UILabel!
    @IBOutlet weak var couponValidDate: UILabel!
    @IBOutlet weak var couponContent: UILabel!
    @IBOutlet weak var couponQty: UILabel!
    @IBOutlet weak var receiveBtn: UIButton!
    
    let firebaseCommunicator = FirebaseCommunicator.shared
    var couponInfo: CouponInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let couponInfo = couponInfo else {
            return
        }
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageURL = "couponImages/\(couponInfo.couponImageName)"
        let localImageURL = cacheURL.appendingPathComponent(imageURL)
        guard let data = try? Data(contentsOf: localImageURL) else {
            return
        }
        couponImage.image = UIImage(data: data)
        couponTitle.text = couponInfo.couponTitle
        couponValidDate.text = "優惠券使用期限: \(couponInfo.couponValidDate)"
        couponContent.text = couponInfo.couponDetilContent
        couponQty.text = "優惠券剩餘 \(couponInfo.couponQty) 張"
        if couponInfo.couponQty == 0 {
            receiveBtn.isEnabled = false
        }
    }
    
    deinit {
        print("Coupon detail deinint.")
    }
    
    // MARK: - Button pressed.
    @IBAction func receiveBtnPressed(_ sender: UIButton) {
        guard let couponID = couponInfo?.couponID else {
            return
        }
        firebaseCommunicator.loadData(collectionName: "couponInfo", documentName: couponID) {[weak self] (info, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("load couponID error: \(error)")
            } else {
                let coupon = info as! [String: Any]
                strongSelf.updateCouponQty(coupon: coupon)
            }
        }
    }
    
    // MARK: - Methods.
    func updateCouponQty(coupon: [String: Any]) {
        // Check coupon Qty from firebase.
        let couponQty = coupon["couponQty"] as! Int
        guard let user = Auth.auth().currentUser?.uid, couponQty > 0 else {
            return
        }
        
        // Check user has this coupon or not.
        if let owner = coupon["owner"] as? [String: Any], owner[user] != nil {
            showAlert()
            return
        }
        var updateOwner = [String: Any]()
        if let owner = coupon["owner"] as? [String: Any] {
            updateOwner = owner
        }
        updateOwner.updateValue(false, forKey: user)
        // Update data to firebase.
        let updateCouponQty = couponQty - 1
        let data = ["couponQty": updateCouponQty, "owner": updateOwner] as [String : Any]
        let couponID = couponInfo?.couponID
        firebaseCommunicator.updateData(collectionName: "couponInfo", documentName: couponID!, data: data) {[weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("updata error: \(error)")
            } else {
                strongSelf.couponQty.text = "優惠券剩餘 \(updateCouponQty) 張"
                if updateCouponQty == 0 {
                    strongSelf.receiveBtn.isEnabled = false
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "您已領取過此優惠券", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
