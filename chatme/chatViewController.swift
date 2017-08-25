//
//  chatViewController.swift
//  chatme
//
//  Created by Syed Shahrukh Haider on 01/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

import MMWormhole

class chatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    
    // COMPONENT INITAILIZATION
    
    @IBOutlet weak var chatMessage: UITableView!
    @IBOutlet weak var messagingTextField: UITextField!
    
    @IBOutlet weak var bottomContact: NSLayoutConstraint!
   
  
    
    
    // VARIABLE FOR WORMHOLE
    let Wormhole = MMWormhole(applicationGroupIdentifier: "group.panacloud.chatme", optionalDirectory: "chatme")
    
    
    // VARIABLE FOR FIREBASE

    var msgRef : DatabaseReference?
    var msgHandle : DatabaseHandle?
    
    
    // VARIABLE FOR THIS CLASS

    var messagesCollection = [String]()
    let Helper = FirebaseHelper()
    var createdChannel : String?

    
    // variable to GET Channel NAME for addressViewController
    static var channelName : String?
    
    
    
    
    
    
    
    
    //  ************************* VIEWDIDLOAD ***************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatMessage.dataSource = self
        chatMessage.delegate = self
        
        messagingTextField.delegate = self

        // Do any additional setup after loading the view.
        
        self.createdChannel = (chatViewController.channelName)!

        
        
        // @@@@@@@@@@@@@@@@@@@@@@ MMWORMHOLE LISTEN OPERATION @@@@@@@@@@@@@@@@@@@
        Helper.listenWormhole()
        
        
       

        // @@@@@@@@@@@@@@@@ METHOD 2:   GET MESSSAGE FROM FIREBASE DATABASE @@@@@@@@@@@@@@@@@@@@@@@
        
        Helper.getMessage(channelName: self.createdChannel!) { (msg) in
            self.messagesCollection.append(msg)
            self.chatMessage.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillHide, object: nil)
        
    }

    
    func keyboardNotification(notification: Notification){
    
        if let userInfo = notification.userInfo{
        
        let keyboardFrame = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
            print(bottomContact.constant)
            print(keyboardFrame)
            
            let isKeyboard = notification.name == .UIKeyboardWillShow
            
            
            bottomContact.constant = isKeyboard ? +keyboardFrame.height : 0
        
        }
    
    }
    
    
    
    
    // ********************** SETTING TABLEVIEW & IT'S CELL ****************************
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesCollection.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = self.messagesCollection[indexPath.row]
        
        return cell
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
 
    
    
    // ************************ SEND BUTTON FUNCTION *************************
  
    @IBAction func sendButton(_ sender: Any) {
        
        
        
        let message = messagingTextField.text
        let channelName = createdChannel!
    
        
        let dict = [message!, channelName]
        
        print(dict)
        // PASS TYPED DATA TO FIREBASE DATABASE
//        Wormhole.passMessageObject(dict as NSArray, identifier: "MESSAGE")
        
        Helper.pushMessage(data: dict)
        messagingTextField.text = ""
        messagingTextField.resignFirstResponder()
        chatMessage.reloadData()
    }
    
 
        
    }


