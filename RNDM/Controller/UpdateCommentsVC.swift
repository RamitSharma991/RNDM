//
//  UpdateCommentsVC.swift
//  RNDM
//
//  Created by Ramit sharma on 13/05/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateCommentsVC: UIViewController {
    
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet var updateBtn: UIButton!
    var commentData : (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        commentTxt.text = commentData.comment.commentText
        
    }
    
    @IBAction func Update(_ sender: Any) {
        Firestore.firestore().collection(THOUGHTS_REF).document(commentData.thought.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text as Any]) { (error) in
            if let error = error {
                debugPrint("Unable to update comment: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
