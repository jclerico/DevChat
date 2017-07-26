//
//  ViewController.swift
//  DevChat
//
//  Created by Jeremy Clerico on 25/07/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import FirebaseAuth

class CameraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

    
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var previewView: AAPLPreviewView!
    
    override func viewDidLoad() {
        //Set Delegate
        delegate = self
        
        //We replaced Apple's previewView in AAPLCameraViewController.swift to _previewView and moved it to AAPLCameraViewController.h to make it a global property. We then set the value of Apples previewView to our new one.
        _previewView = previewView
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Call firbase Auth and grab current user. If there is already a current user, dont run the code.. if there isnt a current user, run the code and show the login screen.
        guard Auth.auth().currentUser != nil else {
            //Load Login VC as there is no existing user
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        } 
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        //Call Parent Class implementation of code
        toggleMovieRecording()
    }
    
    @IBAction func changeCameraBtnPressed(_ sender: Any) {
        //Call Parent Class implementation of code
        changeCamera()
    }
    
    func shouldEnableCameraUI(_ enable: Bool) {
        cameraBtn.isEnabled = enable
        print("Should Enable Camera UI: \(enable)")
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        recordBtn.isEnabled = enable
        print("Should Enable Record UI: \(enable)")
    }
    
    func recordingHasStarted() {
        print("Recording Has Started")
    }
    
    func canStartRecording() {
        print("Can Start Recording")
    }
    
    
    
    
}

