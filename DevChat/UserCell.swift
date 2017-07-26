//
//  UserCell.swift
//  DevChat
//
//  Created by Jeremy Clerico on 26/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set cell to not selected so it has empty checkbox to the right of it.
        setCheckmark(selected: false)
        
    }
    
    //Pass in user so everytime we call the updateUI function were going to pass in the user, so we can update the text label in the userCell.
    func updateUI(user: User) {
        firstNameLbl.text = user.firstName
    }
    
    
    func setCheckmark(selected: Bool) {
        //If user is selected, use the checkmark and if not selected use the box without check in it.
        let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }
    
    
}
