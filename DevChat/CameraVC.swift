//
//  ViewController.swift
//  DevChat
//
//  Created by Jeremy Clerico on 25/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

class CameraVC: AAPLCameraViewController {

    @IBOutlet weak var previewView: AAPLPreviewView!
    
    override func viewDidLoad() {
        //We replaced Apple's previewView in AAPLCameraViewController.swift to _previewView and moved it to AAPLCameraViewController.h to make it a global property. We then set the value of Apples previewView to our new one.
        _previewView = previewView
        
        super.viewDidLoad()
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        //Call Parent Class implementation of code
        toggleMovieRecording()
    }
    
    @IBAction func changeCameraBtnPressed(_ sender: Any) {
        //Call Parent Class implementation of code
        changeCamera()
    }
    
    
    
    
    
    
    
    
}

