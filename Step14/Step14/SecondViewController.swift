//
//  SecondViewController.swift
//  Step14
//
//  Created by omura.522 on 2016/07/04.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {
    
    @IBOutlet weak var point: UITextField!
    @IBOutlet weak var notification: UILabel!
    
    /// 記録処理
    @IBAction func save(_ sender: UIButton) {
        if let user = FIRAuth.auth()?.currentUser {
            guard let point = self.point.text, uid: String = user.uid else {
                return
            }
            let rootRef = FIRDatabase.database().reference()
            rootRef.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                if ( snapshot.value is NSNull ) {
                    self.notification.text = "Not be saved"
                } else {
                    rootRef.child("users/\(user.uid)/point").setValue(point)
                    self.notification.text = "Updated point"
                }
            })
        }
    }
    /// ランキング画面に遷移する
    @IBAction func ranking(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "third") as! ThirdViewController
        self.present(thirdViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FIRAuth.auth()?.currentUser == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

