//
//  UsersVC.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //DataSource based off this
    private var users = [User]()
    
    //Selected Users - String is the UID and User is the unique username. This way, when the user selects a user it gets put in the dictionary, and when the user removes a user it gets taken out of the dictionary. Therefore whatever list of users is in the dictionary when its time to send the media to them we have a whole list.
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        } get {
            return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        //Disable send button as no users will be selected at this point. At didSelectRowAt you can be sure that at least one selected when that function is called.
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //Download data from DataService once
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            //Grab the users & Parse the data from Firebase
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
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        
        //If there is zero users selected, disable the send button
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
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
    
    @IBAction func sendPRBtnPressed(sender: AnyObject) {
        
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            _ = ref.putFile(from: url, metadata: nil, completion: { (meta:StorageMetadata?, err:Error?) in
                
                if err != nil {
                    //Error handling
                    print("Error uploading video: \(err?.localizedDescription)")
                } else {
                    //Once successfully uploaded a video to Firebase, when its done, its going to send back a download URL. This is the URL we give to the other users - They will be able to watch and see straight from Firebase.
                    let downloadURL = meta!.downloadURL()
                    print("Download URL: \(downloadURL)")
                    //Save this somewhere
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else if let snap = _snapData {
            //Handle case of image
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.putData(snap, metadata: nil, completion: { (meta:StorageMetadata?, err:Error?) in
                
                if err != nil {
                    print("Error uploading snapshot: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
