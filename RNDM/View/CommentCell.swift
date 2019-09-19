//
//  CommentCell.swift
//  RNDM
//
//  Created by Ramit sharma on 26/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase

protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}

class CommentCell: UITableViewCell {
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var timestampLbl: UILabel!
    @IBOutlet var commentTextLbl: UILabel!
    @IBOutlet var optionsMenu: UIImageView!
    
    
    private var comment: Comment!
    private var delegate: CommentDelegate?

    
    
    
    func configureCell(comment: Comment, delegate: CommentDelegate?) {
        usernameLbl.text = comment.username
        commentTextLbl.text = comment.commentText
        optionsMenu.isHidden = true
        self.comment = comment
        self.delegate = delegate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampLbl.text = timestamp
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionsMenu.addGestureRecognizer(tap)
        }
    }

    @objc func commentOptionsTapped() {
        delegate?.commentOptionsTapped(comment: comment)
        
    }
}
