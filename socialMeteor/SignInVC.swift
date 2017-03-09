//
//  ViewController.swift
//  socialMeteor
//
//  Created by Evan on 3/8/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var email: textField!
    
    @IBOutlet weak var password: textField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func FBLogin(_ sender: Any) {
        
        let FBlogin = FBSDKLoginManager()
        
        FBlogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Evan: Couldn't authenticate with facebook")
            } else if result?.isCancelled == true {
                print("Evan: user cancelled fb authentication")
            } else {
                print("Evan: authenticated with facebook")
                let cred = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(cred)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("Evan: can't authenticate with firebase")
            } else {
                print("Evan: authenticated with firebase")
            }
        })
        
        
        
    }
    
    @IBAction func NormalLogin(_ sender: Any) {
    }


}

