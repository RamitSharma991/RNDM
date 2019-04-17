//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by Ramit sharma on 17/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit

class AddThoughtVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var categorySegment: UISegmentedControl!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var thoughtTxt: UITextView!
    @IBOutlet var postBtn: UIButton!
    
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
    }
    @IBAction func CategoryChanged(_ sender: Any) {
    }
    

}
