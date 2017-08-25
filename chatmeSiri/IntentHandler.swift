//
//  IntentHandler.swift
//  chatmeSiri
//
//  Created by Syed Shahrukh Haider on 04/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import Intents
import MMWormhole
import Firebase
import FirebaseDatabase
import FirebaseAuth


class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    
    // VARIABLE TO INITILIZE MMWORMHOLE
    
    let Wormhole = MMWormhole(applicationGroupIdentifier: "group.panacloud.chatme", optionalDirectory: "chatme")

    
    // Firebase Variable
    
//    var fbRef : DatabaseReference?
    
    var uid = "12343254354"
    
    
    
    
    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    
    
    
                      //****************** SENDING MESSAGE CODING *****************************
    
    
    
    
    
    
    /*
     
     PHASE 1 : Resolve
     
     
     
     */
    
    
    // ***************** STEP 1 *********************
    
    
    // Retrieving RECIPIENT
    
    
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        
        // Checking Siri understand  User Desire Recipient Name
        if let recipients  = intent.recipients{
            
            
            // IF "CANNOT" UNDERSTAND RECIPIENT NAME
            if recipients.count == 0{
                
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            // IF SIRI RETRIEVE SOME DETAIL
            var resolutionResult = [INPersonResolutionResult]()
            
            for recipient in recipients{
                
                let matchContacts = [recipient]
                
                switch matchContacts.count {
                    
                // DISAMBIGUATION (MULTI RESULT)
                case 2 ... Int.max:
                    resolutionResult = [INPersonResolutionResult.disambiguation(with: matchContacts)]
                    
                // ABLE TO GET SINGLE RESULT
                case 1:
                    resolutionResult = [INPersonResolutionResult.success(with: recipient)]
                // UNSUPPORTED
                case 0:
                    resolutionResult = [INPersonResolutionResult.unsupported()]
                default:
                    break
                }
                
            }
            
            completion(resolutionResult)
            
        }
    }
    
    
    // ***************** STEP 2 *********************
    
    
    // Retrieving CONTENT
    
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            
            completion(INStringResolutionResult.success(with: text))
        }
        else{
            
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    
    /*
     
     PHASE 2 : CONFIRM  (CHECK USER AUTHENTICATION STATUS)
     
     */
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        
        let userAct = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userAct)
        completion(response)
    }
    
    /*
     
     PHASE 3 :   Handle
     
     */
    
    
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        if intent.recipients != nil && intent.content != nil
            // SEND MESSAGE
        {
            
            let userAct = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
            
            let response = INSendMessageIntentResponse(code: .success, userActivity: userAct)
            
            
            // FORWARD RESPONSE TO CHAT VC : TEXTFIELD
            
            
            //          MESSAGE CONTENT
            if let msgContent = intent.content{
                
                if let msgRecip = intent.recipients{
                    
                    
            //          RECIPIENT NAME
                    let recipDisplayName = msgRecip.first?.displayName
                    
                  
                    
                    // CREATING ARRAY TO GENERATE: " CHANNELNAME "
                    let userName = ["Shahrukh", recipDisplayName!]

                    
                    let sortedValue = userName.sorted()
                    let reducedValue = sortedValue.reduce("", {$0+$1})
                    
                    let channelName = reducedValue
                    
                    
                    
                    
                    //********************
                      // checking variable "VALUES"
                    
                      print("uid:\(self.uid) channelName: \(channelName)  message:\(msgContent)")
                    //********************
                    
                    
// @@@@@@@@@@@@@@ FIREBASE METHOD @@@@@@@@@@@@@@@@@@@@
                    
                 // PUSHING DATA TO FIREBASE DATABASE
//                    FirebaseApp.configure()
//                    let fbRef =  Database.database().reference().child("Messages").child(channelName).childByAutoId()
//                    
//                    
                    let dic = [msgContent, channelName]
//                    fbRef.setValue(dic)
                    
        
                    
                    
                    
// @@@@@@@@@@@@@@ MMWORMHOLE METHOD @@@@@@@@@@@@@@@@@@@@
                    
                    
                    
                    Wormhole.passMessageObject(dic as NSArray, identifier: "FROMSIRI")
//                    Wormhole.passMessageObject("\(msgContent)" as NSString, identifier: "contentMsg")
                    
                }
            }
            
            
            completion(response)
            
            
        }
    }
    

    
    
    
    //****************** SEARCH MESSAGE CODING *****************************
    
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
    
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    
    
    
    //****************** ATTRIBUTE MESSAGE CODING *****************************
    
    
    
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(setMessageAttribute intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
    
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }

}










