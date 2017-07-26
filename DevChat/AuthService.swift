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


//Create swift closure/completion handler that we can use over and over (and call at any time). So we know we can pass things in back from this authService file.
typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void


class AuthService {
    private static let _instance = AuthService()
    
    //Getter
    static var instance: AuthService {
        return _instance
    }
    
    //Explanation for login func: Firstly we try to sign in. If there was an error, see what the error code is and if that code is userNotFound, then create a user. Once the user is created, we make sure that theres acutally a user ID (as a second verification), then we go ahead and sign in. After signing in, if theres an error show it otherwise we successfully logged in.
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            //Handling any errors that may occur during signin
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == .userNotFound {
                        //Error is no user found with entered email/password so we create one with what user entered.
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                //Show error to user
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                //Else user ID does exist and proceed to signin in.
                                if user?.uid != nil {
                                    //When creating account, save data to database. NEED this at account creation!!
                                    DataService.instance.saveUser(uid: user!.uid)
                                    //Sign in
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            //Show error to user
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                        } else {
                                            //We have successfully logged in
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    //Handle all other errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully logged in
                onComplete?(nil, user)
            }
        }
    }
    
    //Handle Firebase errors. Good thing about creating an error handler is you can re-use it so you only have to do it once.
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch (errorCode) {
            case .invalidEmail:
                //Keep onComplete optional incase user didnt pass anything in for email and/or password!
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid Password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            case .weakPassword:
                onComplete?("Password too weak. Must be 6 or more characters", nil)
            default:
                onComplete?("there was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    
}
