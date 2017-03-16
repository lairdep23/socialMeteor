//
//  DataService.swift
//  socialMeteor
//
//  Created by Evan on 3/14/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import Foundation
import Firebase

let DB_Base = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_Base
    private var _REF_POSTS = DB_Base.child("posts")
    private var _REF_USERS = DB_Base.child("users")
    
    var refBase: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var refPosts: FIRDatabaseReference{
        return _REF_POSTS
    }
    
    var refUsers: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        refUsers.child(uid).updateChildValues(userData)
    }
    
    
}
