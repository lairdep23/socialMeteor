//
//  postCell.swift
//  socialMeteor
//
//  Created by Evan on 3/9/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: circleImage!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeImage: circleImage!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var numberOfLikes: UILabel!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        likesRef = DataService.ds._REF_USER_CURRENT.child("likes").child(post.postKey)
        self.post = post
        self.postDescription.text = post.caption
        self.numberOfLikes.text = "\(post.likes)"
        
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 3 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("Evan: (Unable to download image) \(error.debugDescription)")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImage.image = UIImage(named: "heart_deselected_icon")
            } else {
                self.likeImage.image = UIImage(named: "heart_selected_icon")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImage.image = UIImage(named: "heart_selected_icon")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "heart_deselected_icon")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
        
    }

}
