//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Ramit sharma on 20/04/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var timestamp: UILabel!
    @IBOutlet var thoughtTextField: UILabel!
    @IBOutlet var likesNum: UILabel!
    @IBOutlet var likesImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(thought: Thought) {
    
    }

}
