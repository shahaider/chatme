//
//  signinViewController.swift
//  chatme
//
//  Created by Syed Shahrukh Haider on 01/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import FirebaseAuth
import Intents

import MMWormhole

class signinViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var helper = FirebaseHelper()
    
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.panacloud.chatme", optionalDirectory: "chatme")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // *********** ENABLE SIRI WHILE APP RUNNING FOR THE FIRST TIME
        INPreferences.requestSiriAuthorization { (SiriAuth) in
            print(SiriAuth)
        
            
            self.helper.listenWormhole()
        }

        
        
        // DEFAULT SIGN IN
        let email = "shahrukh@chatme.com"
        let password = "qwerty"
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if user != nil{
                
                self.performSegue(withIdentifier: "addressSegue", sender: self)
                
            }
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // confirm SIRIKIT about auth status
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            
            if User != nil{
            
                self.wormhole.passMessageObject("TRUE" as NSString, identifier: "AUTH")
            
            }
            else{
                self.wormhole.passMessageObject("FALSE" as NSString, identifier: "AUTH")

            }
        }
        
    }
    
// SIGN IN BUTTON ACTION
    @IBAction func signinButton(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, err) in
            if user != nil{

self.performSegue(withIdentifier: "addressSegue", sender: self)
            
            }
            
        }
        
    }
  


   

}
