//
//  AuthService.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import Foundation
import FirebaseAuth

//This File is a SINGLETON - One copy of this is accessible and available to the entire applicaton.

class AuthService {
    private static let _instance = AuthService()
    
    //Getter
    static var instance: AuthService {
        return _instance
    }
    
    //Explanation for login func: Firstly we try to sign in. If there was an error, see what the error code is and if that code is userNotFound, then create a user. Once the user is created, we make sure that theres acutally a user ID (as a second verification), then we go ahead and sign in. After signing in, if theres an error show it otherwise we successfully logged in.
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            //Handling any errors that may occur during signin
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == .userNotFound {
                        //Error is no user found with entered email/password so we create one with what user entered.
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                //Show error to user
                            } else {
                                //Else user ID does exist and proceed to signin in.
                                if user?.uid != nil {
                                    //Sign in
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            //Show error to user
                                        } else {
                                            //We have successfully logged in
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    //Handle all other errors
                }
            } else {
                //Successfully logged in
            }
        }
    }
    
    
}
