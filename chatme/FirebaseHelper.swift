//
//  FirebaseHelper.swift
//  chatme
//
//  Created by Syed Shahrukh Haider on 03/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import MMWormhole


class FirebaseHelper{


    
    // VARIABLE FOR WORMHOLE

let Wormhole = MMWormhole(applicationGroupIdentifier: "group.panacloud.chatme", optionalDirectory: "chatme")
    
  
    // VARIABLE FOR FIREBASE

    var msgRef : DatabaseReference?
    var msgHandle : DatabaseHandle?
    
    
    // VARIABLE FOR THIS CLASS

                // @@@@@@@@@ RESTORING MESSAGE @@@@@@@@
       var messagesCollection = [String]()
    
                // @@@@@@@@@@@@@ RESTORING CURRENT USER ADDRESS BOOK @@@@@@@@
    static var FirebaseAddressBook = [String]()
   
    
    

    
    
    
    
    
    // ***************** WORMHOLE LISTING FUNCTION ****************
    
    
    func listenWormhole(){
    
        
        // ************** listen via Sender Button ***************
        Wormhole.listenForMessage(withIdentifier: "MESSAGE") { (result) in
            if let value = result{
                
                let msg = value as! [String]
                
                self.pushMessage(data: msg)
            }
            
        }
        
        //  *********** Listen via SiriKit *****************
        
        
        
       
         
//         ===============================================

         
        Wormhole.listenForMessage(withIdentifier: "FROMSIRI") { (result) in
            if let value = result{
                
                let msg = value as! [String]
                
                self.pushMessage(data: msg)
            }
        }
    
    
    
//          ===============================================
        
   
    }
        
        
        
    //******** GETTING MESSAGE FROM FIREBASE DATABASE
    
    func getMessage(channelName: String, completion : @escaping (String) -> Void){
    
        msgRef =  Database.database().reference().child("Messages")
        
        msgHandle = msgRef?.child(channelName).observe(.childAdded, with: { (msgSnapshot) in
            

            if let message = msgSnapshot.value as? [String: Any]{
                
                let messageValue = message["Message"] as? String
                
                
                completion(messageValue!)

            }
            
           
        })
        
    }
    
    
    
    //****************** PLACING MESSAGE FROM FIREBASE DATABASE ******************
    func pushMessage(data: [String]){
    

        print(data)
        let uid = Auth.auth().currentUser?.uid
        let message = data[0]
        let channelname = data[1]
        
            
        let msgRef =  Database.database().reference().child("Messages").child(channelname).childByAutoId()
        
                let dic = ["uID": uid, "Message": message]
                        msgRef.setValue(dic)
     
        }

        

        
    }


