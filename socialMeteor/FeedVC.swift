//
//  FeedVC.swift
//  socialMeteor
//
//  Created by Evan on 3/9/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postCaption: textField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.refPosts.queryOrdered(byChild: "postDate").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts.removeAll(keepingCapacity: false)
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.insert(post, at: 0)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            //var image: UIImage!
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            return cell 
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imagePost.image = image
        } else {
            print("Evan: couldn't add image or wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postImageBtn(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postBtn(_ sender: Any) {
        guard let caption = postCaption.text, caption != "" else {
            print("Evan: Must Enter a Caption")
            return
        }
        
        guard let image = imagePost.image, image != UIImage(named: "camera_icon_snap") else {
            print("Evan: Must select an image")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2){
            
            let imgUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.refPostImages.child(imgUID).put(imgData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print("Evan: unable to upload image to Firebase \(error.debugDescription)")
                } else {
                    print("Evan: uploaded image to Firebase")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let durl = downloadUrl {
                        self.postToFirebase(imgUrl: durl)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, Any> = [
        "caption": postCaption.text!,
        "imageUrl": imgUrl,
        "likes": 0,
        "postDate": FIRServerValue.timestamp()
        ]
        
        let firebasePost = DataService.ds.refPosts.childByAutoId()
        
        firebasePost.setValue(post)
        
        postCaption.text = ""
        imagePost.image = UIImage(named: "camera_icon_snap")
        //print(posts)
        feedTableView.reloadData()
        //print(posts)
    }
    
    
    
    
    @IBAction func signOutBtn(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "SignOutSegue", sender: nil)
    }
    

}
