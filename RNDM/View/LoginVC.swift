//
//  LoginVC.swift
//  RNDM
//
//  Created by Ramit sharma on 23/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var createUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10

    }
    
    
    @IBAction func Login(_ sender: Any) {
        guard let email = emailTxt.text,
        let pswd = passwordTxt.text else { return }
        
        Auth.auth().signIn(withEmail: email, link: pswd) { (user, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func CreateUser(_ sender: Any) {
    }
    

}
