//
//  MainViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/11/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class MainViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var faceBookLoginButton: FBSDKLoginButton!
    
    var authHandle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add the background gradient  背景調成漸層色
        view.addVerticalGradientLayer(topColor: secondaryColor , bottomColor: primaryColor)
        db = Firestore.firestore()
        // Google SignIn
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // FaceBook Login
        faceBookLoginButton.delegate = self
        checkSignInState()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // GIDSignInDelegate Sign後要做的事
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Fail to SignInFor Google (登入失敗)\(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Fail to SignInFor Firebase(Google) (登入失敗)\(error)")
                return
            }
            if let user = authResult?.user{
                print("SignInFor Firebase(Google) (登入成功)")
                print(user.uid)
                self.checkSignInState()
            }
        }
    }
    
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // 當Google用戶在此處與應用程序斷開連接時執行任何操作。
    }
    
    func loginout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("success to loginout(成功登出)")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // FBSDKLoginButtonDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Fail to FBLogin(FB登入失敗)：\(error.localizedDescription)")
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Fail to SignInFor Firebase(FaceBook) (登入失敗)\(error)")
                return
            }
            if let user = authResult?.user{
                print("SignInFor Firebase(FaceBook) (登入成功)")
                print(user.uid)
                self.checkSignInState()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout(登出)")
        do {
            try Auth.auth().signOut()
        } catch {
            print("Fail to logOut FB (FB登出失敗)\(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // Signup 註冊
    func signUp (email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                print("Fail to signUp: \(error.localizedDescription)")
            }
            print("Success signUp : \(String(describing: result?.user))")
            
        }
    }
    
    // SignIn 登入
    func signIn (email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Fail to signIn: \(error)")
                Common.showAlert(on: self, style: .alert, title: "登入失敗", message: "\(error.localizedDescription)")
                return
            }
            guard let user = user else { return }
            print("Success signIn: \(user)")
            self.checkSignInState()
//            self.performSegue(withIdentifier: "segueToUser", sender: self)
        }
    }
    
    // Check SignIn State
    
    func checkSignInState() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        if currentUser.uid == "EFkyc32aNSb8BKHxZX1boudlgEH3" {
            self.performSegue(withIdentifier: "segueToAdmin", sender: self)
        } else if currentUser.uid == "8mFOnxLri9aW7m9SmQDOcVnqazm1" {
            self.performSegue(withIdentifier: "segueToWaiter", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueToUser", sender: self)
        }
    }
    

    @IBAction func BtnPressedSignin(_ sender: Any) {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text else {
            print("Email or Password is nil")
            return
        }
        signIn(email: email, password: password)
        
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "密碼重設！", message: "請確認電子信箱", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let SendAction = UIAlertAction(title: "發送", style: .default) { (action) in
            guard let email = alert.textFields![0].text else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    Common.showAlert(on: self, style: .alert, title: "發送錯誤", message: "\(error.localizedDescription)")
                } else {
                    Common.showAlert(on: self, style: .alert, title: "發送成功", message: "請至信箱檢查重設密碼郵件")
                }
            }
        }
        alert.addTextField { (textField) in
            textField.text = self.textFieldEmail.text
            textField.placeholder = "email"
        }
        alert.addAction(cancelAction)
        alert.addAction(SendAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // 測試用快速登入店長或會員帳號
    
    @IBAction func quickLoginUp(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            textFieldEmail.text = ""
            textFieldPassword.text = ""
        default:
            break
        }
    }
    @IBAction func quicLogunDown(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .down:
            textFieldEmail.text = "user@test.com"
            textFieldPassword.text = "123456"
        default:
            break
        }
    }
    @IBAction func quickLoginLeft(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            textFieldEmail.text = "admin@test.com"
            textFieldPassword.text = "123456"
        default:
            break
        }
    }
    @IBAction func quickLoginRight(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            textFieldEmail.text = "waiter@test.com"
            textFieldPassword.text = "123456"
        default:
            break
        }
    }
    
    
    // Firestore 測試與範例 ============================================================================
    
   
    
    // 新增資料到 測試用集合 檔名自動生成
    func addNewDocumentGeneratedID() {
        var ref: DocumentReference? = nil
        ref = db.collection("測試用集合").document("1").collection("2").addDocument(data: [
            "key": "值",
            "name": "eason",
            "born": 12345
        ]) { error in
            if let  error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID : \(ref!.documentID)")
            }
        }
    }
    
    // 新增檔案 自訂檔名
    func addNewDocument() {
        db.collection("測試用集合").document("檔案名稱").setData([
            "key": "value",
            "說明": "用set 新增檔案，如果已經存在會覆蓋原本資料"
        ]) { error in
            if let  error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        // 新增檔案 如果已經存在會新增
        db.collection("測試用集合").document("檔案名稱").setData(["新增" : "新增的內容"], merge: true)
    }
    
    // 更新檔案部分內容
    func update() {
        db.collection("測試用集合").document("檔案名稱").updateData([
            "記錄最後更新時間": FieldValue.serverTimestamp()
        ]) { error in
            if let  error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    // 讀取集合內所有檔案
    func loadDatas() {
        db.collection("測試用集合").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) ====> \(document.data())")
                }
            }
        }
    }
    
    // 讀取固定檔案
    func loadDocument() {
        db.collection("測試用集合").document("檔案名稱").getDocument { (document, err) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document odes not exists")
            }
        }
    }
    
    // 讀取符合條件的檔案
    func loadDocumentEqualTo() {
        db.collection("測試用集合").whereField("name", isEqualTo: "eason").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) ====> \(document.data())")
                }
            }
        }
    }
    
}


//關閉鍵盤
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
