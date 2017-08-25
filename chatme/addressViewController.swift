//
//  addressViewController.swift
//  chatme
//
//  Created by Syed Shahrukh Haider on 01/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// SIRIKIT
import Intents

// ADDRESS MMWORMHOLE
import MMWormhole



class addressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var addressbook: UITableView!


    // VARIABLE FOR FIREBASE
    var addressRef : DatabaseReference?
    var addresshandler : DatabaseHandle?
    
    // VARIABLE OF THIS CLASS
    var friendList = [String]()
    var friendPhoto = [String]()
    
    var sender = ""
    
    var helper = FirebaseHelper()
    
    // MMWORMHOLE VARIABLE
    
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.panacloud.chatme", optionalDirectory: "chatme")
    
    var addressResolutionResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.helper.listenWormhole()

        addressbook.dataSource = self
        addressbook.delegate = self
        
        addressRef = Database.database().reference().child("Users")
        addresshandler = addressRef?.observe(.childAdded, with: { (userSnap) in
            
            
            if  let fetchData = userSnap.value as? [String : String]{
            
                if fetchData["uid"] == Auth.auth().currentUser?.uid{
                let name = fetchData["Name"]
                    print(name!)
                    self.sender = name!
                }
                
                 // @@@@@@@@@@@@@ REMOVE SIGN IN USER @@@@@@@@@@@@@@@@@@@@@@@
                if fetchData["uid"] != Auth.auth().currentUser?.uid {
                
                    
                    
//                // @@@@@@@@@@@@@@ CREATE ADDRESS-BOOK @@@@@@@@@@@@@@@@
//                let result = fetchData
//                
                    
                    
                // @@@@@@@@@@@@ FirebaseHelper @@@@@@@@@@@@@@
//                FirebaseHelper.FirebaseAddressBook.append(result["Name"])
                
                self.friendList.append(fetchData["Name"]!)
                self.friendPhoto.append(fetchData["photo"]!)
                    
                    print(self.friendList)
                    print(self.friendPhoto)
                
                // @@@@@@@@@@@@@@@ tableview Reload @@@@@@@@@@@@@@@@@@
                self.addressbook.reloadData()
                    
            }
            }
        })
 

        
                
        // **************** PASSING VALUE TO SIRIKIT ************************
        
        
        // ------- matched Contact detail ----------------
        wormhole.passMessageObject(addressResolutionResult as NSArray, identifier: "APP TO INTENT")
        
        // ----------- SENDER DISPLAY NAME --------------
        wormhole.passMessageObject(self.sender as NSString, identifier: "SENDER")
        
        
        
        //  *************** LISTEN VALUE FROM SIRIKIT ************************
        self.wormhole.listenForMessage(withIdentifier: "INTENT TO APP", listener: { (recipientValue) in
            if let value = recipientValue as? String{
                
                for member in self.friendList{
                    
                    if value == member{
                        self.addressResolutionResult.append(member)
                        
                    }
                    
                }
                
            }
        })

    }
    
 
    
    
   
    
    
    
    // **************** CONFIGURE TABLEVIEW ********************

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
  

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatmeViewCell") as! TableViewCell
        cell.nameLabel.text = friendList[indexPath.row]
        
        let photolink =  friendPhoto[indexPath.row]
        let photoUrl = URL(string: photolink)
        let photodata = NSData(contentsOf: photoUrl!)
        
        let photo = UIImage(data: photodata as! Data)
        cell.userImage.image = photo
        
        return cell
    
        
    }
    
    
    // ****************** ON SELECTING/ TAPPING PARTICULAR CELL ******************
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let receiever = friendList[indexPath.row]
        
        print(self.sender)
    
        let uidArray = [self.sender, receiever]
        
        
        
        let sortedValue = uidArray.sorted()
        let reducedValue = sortedValue.reduce("", {$0+$1})
        
        chatViewController.channelName = reducedValue
        
        print(reducedValue)
        
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
   

}
