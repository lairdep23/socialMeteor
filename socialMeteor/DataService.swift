//
//  DataService.swift
//  socialMeteor
//
//  Created by Evan on 3/14/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_Base = FIRDatabase.database().reference()
let StorageBase = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB References
    
    private var _REF_BASE = DB_Base
    private var _REF_POSTS = DB_Base.child("posts")
    private var _REF_USERS = DB_Base.child("users")
    
    //Storage References
    
    private var _REF_Post_Images = StorageBase.child("post-pics")
    
    var refBase: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var refPosts: FIRDatabaseReference{
        return _REF_POSTS
    }
    
    var refUsers: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var _REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: keyUID)
        let user = _REF_USERS.child(uid!)
        return user 
    }
    
    var refPostImages: FIRStorageReference {
        return _REF_Post_Images
    }
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        refUsers.child(uid).updateChildValues(userData)
    }
    
    
}
