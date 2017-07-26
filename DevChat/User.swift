//
//  User.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

//Structs are better for raw data types whenever possible
struct User {
    private var _firstName: String
    private var _uid: String
    
    var uid:String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
}
