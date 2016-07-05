//
//  ViewController.swift
//  Step14
//
//  Created by omura.522 on 2016/07/01.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        notification.text = ""
    }
    /// 登録処理
    @IBAction func register(_ sender: UIButton) {
        guard let email = self.email.text, password = self.password.text else {
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error:NSError?) in
            if let error = error {
                self.notification.numberOfLines = 2
                self.notification.text = "Creating the user failed! \n \(error.userInfo["NSLocalizedDescription"]!)"
                return
            }
            
            if let user = user {
                guard let uid: String = user.uid, name = self.name.text, email = self.email.text else {
                    return
                }
                let rootRef = FIRDatabase.database().reference()
                rootRef.child("users").child(uid).setValue(["name": name, "email": email, "point": 0])
                self.notification.text = "user : \(user.email) has been created successfully."
            }
        })
    }
    /// ログイン処理
    @IBAction func login(_ sender: UIButton) {
        guard let email = email.text, password = password.text else {
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.notification.numberOfLines = 2
                self.notification.text = "Login failed! \n \(error.userInfo["NSLocalizedDescription"]!)"
                return
            }
            // Game画面に遷移する
            let storyboard: UIStoryboard = self.storyboard!
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "second") as! SecondViewController
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

