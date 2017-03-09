//
//  postCell.swift
//  socialMeteor
//
//  Created by Evan on 3/9/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: circleImage!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeImage: circleImage!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
