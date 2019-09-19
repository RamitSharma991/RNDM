//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Ramit sharma on 20/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase

protocol ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}

class ThoughtCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var thoughtTextField: UILabel!
    @IBOutlet var likesNum: UILabel!
    @IBOutlet var likesImg: UIImageView!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var commentsNumLbl: UILabel!
    @IBOutlet var optionsMenu: UIImageView!
    
    private var thought: Thought!
    private var delegate: ThoughtDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
    Firestore.firestore().document("thoughts/\(thought.documentId!)").updateData([NUM_LIKES : thought.numLikes + 1])
        
    }
    
    
    func configureCell(thought: Thought, delegate: ThoughtDelegate?) {
        optionsMenu.isHidden = true
        self.thought = thought
        self.delegate = delegate
        username.text = thought.username
  //      timestamp.text = String(thought.timestamp)
        thoughtTextField.text = thought.thoughtTxt
        likesNum.text = String(thought.numLikes)
        commentsNumLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLabel.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped))
            optionsMenu.addGestureRecognizer(tap)
        }
    }

    @objc func thoughtOptionsTapped() {
        
        delegate?.thoughtOptionsTapped(thought: thought)
        
        
    }
}
