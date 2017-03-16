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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var email: textField!
    
    @IBOutlet weak var password: textField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: keyUID) {
            performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSigin(id: user.uid, userData: userData)
                    
                }
                
            }
        })
        
        
        
    }
    
    @IBAction func NormalLogin(_ sender: Any) {
        
        if let e_mail = email.text, let pass = password.text {
            FIRAuth.auth()?.signIn(withEmail: e_mail, password: pass, completion: { (user, error) in
                if error == nil {
                    print("Evan: User Signed In")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSigin(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: e_mail, password: pass, completion: { (user, error) in
                        if error  != nil {
                            print("Evan:Unable to authenticate with firebase")
                            print("\(error)")
                        } else {
                            print("Evan: Created user with email")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSigin(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
            
        } else {
            print("Need to put in an email and password")
        }
    }
    
    func completeSigin(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: keyUID)
        performSegue(withIdentifier: "SignInSegue", sender: nil)
    }


}

