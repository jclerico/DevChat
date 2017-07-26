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
import FirebaseStorage

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
    
    //Reference to Firebase Storage
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://devchat-b4980.appspot.com/")
    }
    
    var imagesStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: StorageReference {
        return mainStorageRef.child("videos")
    }
    
    
    
    
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": "" as AnyObject, "lastName": "" as AnyObject]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
    
    //Send Pull Request
    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>, mediaURL: URL, textSnippit: String? = nil) {
        
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
            
        }
        
        var pr: Dictionary<String, AnyObject> = ["mediaURL":mediaURL.absoluteString as AnyObject, "userID":senderUID as AnyObject, "openCount": 0 as AnyObject, "recipients": uids as AnyObject]
        
        //Save it
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
