//
//  DataService.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

//NOTE: For .child("abcd"), its best to put the reference to the database in a constant file so you keep continuity and no typing errors are made! -- ie   let CHILD_ABCD = "abcd" .Example Use: .child(CHILD_ABCD)

let FIR_CHILD_USERS = "users"

import Foundation
import FirebaseDatabase

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference() //Grab reference to app specific database.
    }
    
    //Reference to users in Firebase DB
    var usersRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": "" as AnyObject, "lastName": "" as AnyObject]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
}
