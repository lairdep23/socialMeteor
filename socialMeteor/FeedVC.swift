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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    
    
    
    
    
    @IBAction func signOutBtn(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "SignOutSegue", sender: nil)
    }
    

}
