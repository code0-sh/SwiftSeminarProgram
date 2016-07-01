//
//  ViewController.swift
//  Step14
//
//  Created by omura.522 on 2016/07/01.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorText.text = ""
    }

    @IBAction func register(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user:FIRUser?, error:NSError?) in
            if let error = error {
                self.errorText.text = "Creating the user failed! \(error.userInfo["NSLocalizedDescription"]!)"
                return
            }
            
            if let user = user {
                print("user : \(user.email) has been created successfully.")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

