//
//  LoginVC.swift
//  DevChat
//
//  Created by Jeremy Clerico on 25/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //Handle Validation to make sure that each field is not nil. Text fields will be considered valid if it contains an empty string, and so we check the characters are > 0 to stop this.
        if let email = emailField.text, let pass = passwordField.text , (email.characters.count > 0 && pass.characters.count > 0) {
            
            //Call Login Service
            AuthService.instance.login(email: email, password: pass, onComplete: { (errMsg, data) in
                
                //Dismiss LoginVC if successfully logged in. (Guard means if errMsg == nil passes, dont run the code. if it fails, run it)
                guard errMsg == nil else {
                    let alert = UIAlertController(title: "Error Authenticating", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //If successful login execute this code
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            //Else if email and/or password field is nil create an alert.
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
            
            //Action for the alert so user is able to close the alert.
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            //Present the alert to the user.
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
}
