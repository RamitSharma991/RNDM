//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by Ramit sharma on 17/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var categorySegment: UISegmentedControl!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var thoughtTxt: UITextView!
    @IBOutlet var postBtn: UIButton!
    
    //properties
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //btn customization
        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        // custom placeholder text
        thoughtTxt.text = "My random thought is....."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    
    @IBAction func Post(_ sender: Any) {
        
        guard let username = usernameTxt.text else { return }
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [CATEGORY : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt.text,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username
        ]) {
            (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    @IBAction func CategoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue

            
        }
        
    }
    

}
