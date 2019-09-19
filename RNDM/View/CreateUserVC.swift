//
//  CreateUserVC.swift
//  RNDM
//
//  Created by Ramit sharma on 23/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase


class CreateUserVC: UIViewController {
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var pswdTxt: UITextField!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var createBtn: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
   }
    @IBAction func CreateUser(_ sender: Any) {
        guard let email = emailTxt.text,
            let password = pswdTxt.text,
            let username = usernameTxt.text else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("error creating user: \(error.localizedDescription)")
        }
            
            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion:{ (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                
            })
            guard let userID = user?.user.uid else { return }
            Firestore.firestore().collection(USER_REF).document(userID).setData([USERNAME : username, DATE_CREATED: FieldValue.serverTimestamp], completion: { (error) in
                
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @IBAction func Cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
