//
//  PHOTOViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase

class PHOTOViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let getphoto = Getphoto()
    let communicator = FirebaseCommunicator.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // 詢問使用者取用相簿授權
        PHPhotoLibrary.requestAuthorization { (status) in
            print("PHPhotoLibrary.requestAuthorization:\(status.rawValue)")
        }
        Photo.setImage(getphoto.update(), for: .normal)
        
        
    }
    
    @IBAction func Picture(_ sender: UIButton) {
        //取得同意授權鈕
        let alert = UIAlertController(title: "Please chouse source:", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.launchPicker(sourse: .camera)
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.launchPicker(sourse: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true)
        
        
    }
    
    @IBOutlet weak var Photo: UIButton!
    
    
    //相機
    func launchPicker(sourse: UIImagePickerController.SourceType) {
        //查看有無Sourse
        guard UIImagePickerController.isSourceTypeAvailable(sourse) else {
            print("Invalid source type")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage,kUTTypeMovie] as [String]
        picker.sourceType = sourse
        picker.allowsEditing = true // 編輯照片
        
        present(picker , animated: true)
    }
    static var selectedImageFromPicker: UIImage?
    //接收照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("info:\(info)")
        guard let type = info[.mediaType] as? String else {
            assertionFailure("Invalid type")
            return
        }
        if type == (kUTTypeImage as String){
            guard let originalImage = info[.originalImage] as? UIImage else {
                assertionFailure("originalImage is nil")
                return
            }
            let resizedImage = originalImage.resize(maxEdge: 1024)!
            
            //上傳照片
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else {
                print("uid is nil")
                return
            }
            // 取得從 UIImagePickerController 選擇的檔案
            communicator.sendPhoto(selectedImageFromPicker: resizedImage, uniqueString: currentUserUid )
            print("uid: \(currentUserUid)")
            self.viewDidLoad()
            self.viewWillAppear(true)
        } else if type == (kUTTypeMovie as String){
            
        }
        picker.dismiss(animated: true)//不加picker會凍結
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
