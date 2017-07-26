//
//  UsersVC.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //DataSource based off this
    private var users = [User]()
    
    //Selected Users - String is the UID and User is the unique username. This way, when the user selects a user it gets put in the dictionary, and when the user removes a user it gets taken out of the dictionary. Therefore whatever list of users is in the dictionary when its time to send the media to them we have a whole list.
    private var selectedUsers = Dictionary<String, User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        //Download data from DataService once
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            //Grab the users
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                //Iterate through this array using a for in loop using a tuple. Everytime it goes through users it will pass us the key and the value.
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                
                                //Create new user object with the data we pulled from the Database, and then append that user to the user list array.
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    
}
