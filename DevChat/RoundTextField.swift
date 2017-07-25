//
//  RoundTextField.swift
//  DevChat
//
//  Created by Jeremy Clerico on 25/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

@IBDesignable //Shows changes in interface builder

class RoundTextField: UITextField {
    
    //IBDesignable creates a property (below) that we can toggle/move on interface builder and every time that changes its going to call the didSet section. (Set default = 0)
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            //rawString Explanation: This is a ternary operator (ie working on 3 thing hence the != and ?).                           
            //Its basically saying: Is there an attribute of string ? If so, use that string and unwrap it as we know its NOT going to be nil and therefore not crash. IF it IS NIL, use the empty string ""
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSForegroundColorAttributeName: placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    
}
