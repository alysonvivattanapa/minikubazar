//
//  ClientService.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/20/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

//BaseAPIService could be a better name
struct ClientService {
    
    static let rootRef = FIRDatabase.database().reference()
    
    // Database URL is automatically determined from GoogleService-Info.plist
    
    static let profileRef = rootRef.child("profile")
    
    static let oneSignalIDsRef = rootRef.child("oneSignalIDs")
    
    static let activeHaikusRef = rootRef.child("activeHaikus")
    
    static let completedHaikusRef = rootRef.child("completedHaikus")
    
    static let friendsRef = rootRef.child("friends")
    
    static let blockedFriendsRef = rootRef.child("blockedFriends")
    
    static let storage = FIRStorage.storage()
    
    static let storageRef = storage.reference(forURL: "gs://kubazar-5.appspot.com")
    
    static let imagesRef = storageRef.child("images")
    
    static let newCompletedHaikusRef = rootRef.child("newCompletedHaikus")
    
    static func getCurrentUser(_ closure: (FIRUser) -> Void) {
        
        if let user = FIRAuth.auth()?.currentUser {
        closure(user)
        } else {
             print("no user is currently logged in")
        }
        
    }
    
    static func getCurrentUserUID() -> String {
        
        
        if let user = FIRAuth.auth()?.currentUser {
            return user.uid } else {
            return "no user id"
        }
    }
    
    static func getCurrentUserEmail() -> String {
        if let user = FIRAuth.auth()?.currentUser {
            return user.email! } else {
            return "no email address?"
        }
    }
    
    
    static func getFriendUIDsForCurrentUser(_ closure: @escaping ([String]) -> Void) {
        
        let currentUserUiD = getCurrentUserUID()
        
        friendsRef.child("\(currentUserUiD)").queryOrderedByKey().observe(.value, with: { snapshot in
            
            var arrayOfFriendUIDs = [String]()
            
            for item in snapshot.children {
                
                let newItem = (item as! FIRDataSnapshot).value as! NSDictionary
                
                let friendUID = newItem.value(forKey: "uid") as! String
                
                arrayOfFriendUIDs.append(friendUID)
            }
            
            closure(arrayOfFriendUIDs)
            
        })
        
    }
    
    static func getActiveHaikuObjectsForCurrentUser(_ closure: @escaping ([ActiveHaiku]) -> Void) {
        
        let currentUserUid = getCurrentUserUID()
        
       activeHaikusRef.child("\(currentUserUid)").queryOrdered(byChild: "timestamp").observe(.value, with: { snapshot in
            
            var arrayOfActiveHaikuObjects = [ActiveHaiku]()
        
        for haiku in snapshot.children {
            
            let newHaiku = (haiku as! FIRDataSnapshot).value as! NSDictionary
            
            let firstLineString = newHaiku.value(forKey: "firstLineString") as! String
            
            let secondLineString = newHaiku.value(forKey: "secondLineString") as! String
            
            let thirdLineString = newHaiku.value(forKey: "thirdLineString") as! String
            let firstPlayerUUID = newHaiku.value(forKey: "firstPlayerUUID") as! String
            let secondPlayerUUID = newHaiku.value(forKey: "secondPlayerUUID") as! String
            
            let thirdPlayerUUID = newHaiku.value(forKey: "thirdPlayerUUID") as! String
            
            let imageURLString = newHaiku.value(forKey: "imageURLString") as! String
            let uniqueHaikuUUID = newHaiku.value(forKey: "uniqueHaikuUUID") as! String
            
            let timestamp = newHaiku.value(forKey: "timestamp") as AnyObject
            
            let firstPlayerEmail = newHaiku.value(forKey: "firstPlayerEmail") as! String
            
            let secondPlayerEmail = newHaiku.value(forKey: "secondPlayerEmail") as! String
            
            let thirdPlayerEmail = newHaiku.value(forKey: "thirdPlayerEmail") as! String
            
            let turnCounterString = newHaiku.value(forKey: "turnCounter") as! String
            
            let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, firstPlayerEmail: firstPlayerEmail, secondPlayerUUID: secondPlayerUUID, secondPlayerEmail: secondPlayerEmail, thirdPlayerUUID: thirdPlayerUUID, thirdPlayerEmail: thirdPlayerEmail, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: timestamp, turnCounter: turnCounterString)
            
//            let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, secondPlayerUUID: secondPlayerUUID, thirdPlayerUUID: thirdPlayerUUID, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: timestamp)
            
            
             arrayOfActiveHaikuObjects.append(newHaikuObject)
            
        }
        
         closure(arrayOfActiveHaikuObjects.reversed())
        
        })
    }
    
    
    static func getCompletedHaikuObjectsForCurrentUser(_ closure: @escaping ([ActiveHaiku]) -> Void) {
        
        let currentUserUid = getCurrentUserUID()
        
        newCompletedHaikusRef.child("\(currentUserUid)").queryOrdered(byChild: "timestamp").observe(.value, with: { snapshot in
            
            var arrayOfCompletedHaikuObjects = [ActiveHaiku]()
            
            for haiku in snapshot.children {
                
                let newHaiku = (haiku as! FIRDataSnapshot).value as! NSDictionary
                
                let firstLineString = newHaiku.object(forKey: "firstLineString") as! String
                
                let secondLineString = newHaiku.object(forKey: "secondLineString") as! String
                
                let thirdLineString = newHaiku.object(forKey: "thirdLineString") as! String
                
                let firstPlayerUUID = newHaiku.object(forKey: "firstPlayerUUID") as! String
                let secondPlayerUUID = newHaiku.object(forKey: "secondPlayerUUID") as! String
                let thirdPlayerUUID = newHaiku.object(forKey: "thirdPlayerUUID") as! String
                let imageURLString = newHaiku.object(forKey: "imageURLString") as! String
                let uniqueHaikuUUID = newHaiku.object(forKey: "uniqueHaikuUUID") as! String
                
                let timestamp = newHaiku.object(forKey: "timestamp") as AnyObject
                
//                let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, secondPlayerUUID: secondPlayerUUID, thirdPlayerUUID: thirdPlayerUUID, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: timestamp)
                
                let firstPlayerEmail = newHaiku.value(forKey: "firstPlayerEmail") as! String
                
                let secondPlayerEmail = newHaiku.value(forKey: "secondPlayerEmail") as! String
                
                let thirdPlayerEmail = newHaiku.value(forKey: "thirdPlayerEmail") as! String
                
                let turnCounterString = newHaiku.value(forKey: "turnCounter") as! String
                
                let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, firstPlayerEmail: firstPlayerEmail, secondPlayerUUID: secondPlayerUUID, secondPlayerEmail: secondPlayerEmail, thirdPlayerUUID: thirdPlayerUUID, thirdPlayerEmail: thirdPlayerEmail, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: timestamp, turnCounter: turnCounterString)

                
                arrayOfCompletedHaikuObjects.append(newHaikuObject)
            }
            
            closure(arrayOfCompletedHaikuObjects.reversed())
            
        })
    }

    
    
    
    
//    static func getCompletedHaikuImageURLStringsForCurrentUser(closure: [String] -> Void) {
//        
//        let currentUserUid = getCurrentUserUID()
//        
//        newCompletedHaikusRef.child("\(currentUserUid)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
//            
//            var arrayOfCompletedHaikuImageURLStrings = [String]()
//            
//            for item in snapshot.children {
//                
//                let completedHaikuImageURLString = item.value.objectForKey("imageURLString") as! String
//                
//                arrayOfCompletedHaikuImageURLStrings.append(completedHaikuImageURLString)
//                
//            }
//            
//            closure(arrayOfCompletedHaikuImageURLStrings)
//            
//        })
//        
//    }
    
    static func getFriendEmailsForCurrentUser(_ closure: @escaping ([String]) -> Void) {
        
        let currentUserUiD = getCurrentUserUID()
        
        friendsRef.child("\(currentUserUiD)").queryOrderedByKey().observe(.value, with: { snapshot in
            
            var friendEmails = [String]()
            
            for item in snapshot.children {
                
                let newItem = (item as! FIRDataSnapshot).value as! NSDictionary
                
                let friendEmail = newItem.object(forKey: "email") as! String
                
                friendEmails.append(friendEmail)
            }
            
            //             print(users)
            
            closure(friendEmails)
            
        })
        
    }

    static func addFriendToCurrentUserFriendsList (_ friend: User) {
        let currentUserUID = ClientService.getCurrentUserUID()
        let currentUserFriendsRef = friendsRef.child(currentUserUID)
        
        if let uid = friend.uid,
            let email = friend.email,
            let username = friend.username {
            
            let userDictionary: NSDictionary = ["uid": uid, "email": email, "username": username]
                
        currentUserFriendsRef.child(uid).setValue(userDictionary)
        }
    }
    
    static func blockFriend (_ friend: User) {
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        let currentUserFriendsRef = friendsRef.child(currentUserUID)
        
        let currentUserBlockedFriendsRef = blockedFriendsRef.child(currentUserUID)
        
        if let uid = friend.uid, let email = friend.email, let username = friend.username {
            
             let userDictionary: NSDictionary = ["uid": uid, "email": email, "username": username]
            currentUserBlockedFriendsRef.child(uid).setValue(userDictionary)
            
        currentUserFriendsRef.child(uid).removeValue()
            
        }
        
        
    }
    
//    static func addActiveHaikuForSoloPlayer (_ activeHaiku: ActiveHaiku) {
//        
//    }
    
    static func addActiveHaikuForPlayers (_ activeHaiku: ActiveHaiku) {
        let currentUserUID = ClientService.getCurrentUserUID()
        let currentUserActiveHaikusRef = activeHaikusRef.child(currentUserUID)
        
//        let firstLineString = activeHaiku.firstLineString
//        let secondLineString = activeHaiku.secondLineString
//        let thirdLineString = activeHaiku.thirdLineString
//        let imageURLString = activeHaiku.imageURLString
//        let firstPlayerUUID = activeHaiku.firstPlayerUUID
//        let secondPlayerUUID = activeHaiku.secondPlayerUUID
//        let thirdPlayerUUID = activeHaiku.thirdPlayerUUID
//        let uniqueHaikuUUID = activeHaiku.uniqueHaikuUUID
////        let currentTimestamp = FIRServerValue.timestamp() as AnyObject
//        let currentTimestamp = activeHaiku.timestamp
//        let firstPlayerEmail = activeHaiku.firstPlayerEmail
//        let secondPlayerEmail = activeHaiku.secondPlayerEmail
//        let thirdPlayerEmail = activeHaiku.thirdPlayerEmail
//        let turnCounter = activeHaiku.turnCounter
//        
           let activeHaikuDictionary: NSDictionary = ["firstLineString": activeHaiku.firstLineString, "secondLineString": activeHaiku.secondLineString, "thirdLineString": activeHaiku.thirdLineString, "imageURLString": activeHaiku.imageURLString, "firstPlayerUUID": activeHaiku.firstPlayerUUID, "firstPlayerEmail": activeHaiku.firstPlayerEmail, "secondPlayerUUID": activeHaiku.secondPlayerUUID, "secondPlayerEmail": activeHaiku.secondPlayerEmail, "thirdPlayerUUID": activeHaiku.thirdPlayerUUID, "thirdPlayerEmail": activeHaiku.thirdPlayerEmail, "uniqueHaikuUUID": activeHaiku.uniqueHaikuUUID, "timestamp": activeHaiku.timestamp, "turnCounter": activeHaiku.turnCounter]
        
//        let activeHaikuDictionary: NSDictionary = ["firstLineString": firstLineString!, "secondLineString": secondLineString!, "thirdLineString": thirdLineString!, "imageURLString": imageURLString!, "firstPlayerUUID": firstPlayerUUID!, "secondPlayerUUID": secondPlayerUUID!, "thirdPlayerUUID": thirdPlayerUUID!, "uniqueHaikuUUID": uniqueHaikuUUID!, "timestamp": currentTimestamp]
        
        currentUserActiveHaikusRef.child(activeHaiku.uniqueHaikuUUID).setValue(activeHaikuDictionary)
        
        if currentUserUID != activeHaiku.firstPlayerUUID {
            let firstPlayerActiveHaikusRef = activeHaikusRef.child(activeHaiku.firstPlayerUUID)
            firstPlayerActiveHaikusRef.child(activeHaiku.uniqueHaikuUUID).setValue(activeHaikuDictionary)
        }

        
        if currentUserUID != activeHaiku.secondPlayerUUID {
            let secondPlayerActiveHaikusRef = activeHaikusRef.child(activeHaiku.secondPlayerUUID)
            secondPlayerActiveHaikusRef.child(activeHaiku.uniqueHaikuUUID).setValue(activeHaikuDictionary)
        }
        
        if currentUserUID != activeHaiku.thirdPlayerUUID {
            let thirdPlayerActiveHaikusRef = activeHaikusRef.child(activeHaiku.thirdPlayerUUID)
            
            thirdPlayerActiveHaikusRef.child(activeHaiku.uniqueHaikuUUID).setValue(activeHaikuDictionary)
        }
        
    }
    
//    static func addActiveHaikuForFriend (activeHaiku: ActiveHaiku) {
//        
//    }
//    
    static func fetchActiveHaikuAndMoveToNewCompletedHaikus (_ uniqueHaikuUUID: String, thirdLineTextString: String) {
        
        print("THIS CLIENT SERVICE FUNCTION SHOULD BE TRIGGGERED OF THIRD TEXT FIELD WAS EDITED for unique id \(uniqueHaikuUUID)")
        
        let currentUserUID = getCurrentUserUID()
        
        activeHaikusRef.child("\(currentUserUID)/\(uniqueHaikuUUID)").queryOrderedByKey().observe(.value, with: { snapshot in
            
            if snapshot.exists() {
            print("CURRENT ACTIVE HAIKU FROM FETCH ACTIVE HAIKU FUCNTION \(snapshot)")
                
            let activeHaiku = snapshot.value as! NSDictionary
                
            let firstLine = activeHaiku.object(forKey: "firstLineString") as! String
            
            let secondLine = activeHaiku.object(forKey: "secondLineString") as! String

            let imageURL = activeHaiku.object(forKey: "imageURLString") as! String

            let firstPlayer = activeHaiku.object(forKey: "firstPlayerUUID") as! String

            let secondPlayer = activeHaiku.object(forKey: "secondPlayerUUID") as! String
                
            let thirdPlayer = activeHaiku.object(forKey: "thirdPlayerUUID") as! String
                
            let firstPlayerEmail = activeHaiku.object(forKey: "firstPlayerEmail") as! String
                
            let secondPlayerEmail = activeHaiku.object(forKey: "secondPlayerEmail") as! String
            
            let thirdPlayerEmail = activeHaiku.object(forKey: "thirdPlayerEmail") as! String
                
                
//            let timestamp = activeHaiku.object(forKey: "timestamp")
                
                let completedTimestamp = FIRServerValue.timestamp() as AnyObject
         
let newCompleteHaiku = ActiveHaiku(firstLineString: firstLine, secondLineString: secondLine, thirdLineString: thirdLineTextString, imageURLString: imageURL, firstPlayerUUID: firstPlayer, firstPlayerEmail: firstPlayerEmail, secondPlayerUUID: secondPlayer, secondPlayerEmail: secondPlayerEmail, thirdPlayerUUID: thirdPlayer, thirdPlayerEmail: thirdPlayerEmail, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: completedTimestamp, turnCounter: "3")
                
//                let newCompleteHaiku = ActiveHaiku(firstLineString: firstLine, secondLineString: secondLine, thirdLineString: thirdLineTextString, imageURLString: imageURL, firstPlayerUUID: firstPlayer, secondPlayerUUID: secondPlayer, thirdPlayerUUID: thirdPlayer, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: completedTimestamp)
            
                 let newCompleteHaikuDictionary: NSDictionary = ["firstLineString": newCompleteHaiku.firstLineString, "secondLineString": newCompleteHaiku.secondLineString, "thirdLineString": newCompleteHaiku.thirdLineString, "imageURLString": newCompleteHaiku.imageURLString, "firstPlayerUUID": newCompleteHaiku.firstPlayerUUID, "firstPlayerEmail": newCompleteHaiku.firstPlayerEmail, "secondPlayerUUID": newCompleteHaiku.secondPlayerUUID, "secondPlayerEmail": newCompleteHaiku.secondPlayerEmail, "thirdPlayerUUID": newCompleteHaiku.thirdPlayerUUID, "thirdPlayerEmail": newCompleteHaiku.thirdPlayerEmail, "uniqueHaikuUUID": newCompleteHaiku.uniqueHaikuUUID, "timestamp": newCompleteHaiku.timestamp, "turnCounter": newCompleteHaiku.turnCounter]
                
//            let newCompleteHaikuDictionary: NSDictionary = ["firstLineString": newCompleteHaiku.firstLineString, "secondLineString": newCompleteHaiku.secondLineString, "thirdLineString": newCompleteHaiku.thirdLineString, "imageURLString": newCompleteHaiku.imageURLString, "firstPlayerUUID": newCompleteHaiku.firstPlayerUUID, "secondPlayerUUID": newCompleteHaiku.secondPlayerUUID, "thirdPlayerUUID": newCompleteHaiku.thirdPlayerUUID, "uniqueHaikuUUID": newCompleteHaiku.uniqueHaikuUUID, "timestamp": newCompleteHaiku.timestamp]
            
           let currentUserNewCompletedHaikusRef = newCompletedHaikusRef.child(currentUserUID)
            
            currentUserNewCompletedHaikusRef.child(uniqueHaikuUUID).setValue(newCompleteHaikuDictionary)
                
                
                if let firstUser = newCompleteHaiku.firstPlayerUUID {
                    
                    if firstUser != currentUserUID {
                        let firstUserNewCompletedHaikusRef = newCompletedHaikusRef.child(firstUser)
                        firstUserNewCompletedHaikusRef.child(uniqueHaikuUUID).setValue(newCompleteHaikuDictionary)
                    }
                    
                }
                
                if let secondUser = newCompleteHaiku.secondPlayerUUID {
                    
                    if secondUser != currentUserUID {
                        let secondUserNewCompletedHaikusRef = newCompletedHaikusRef.child(secondUser)
                        secondUserNewCompletedHaikusRef.child(uniqueHaikuUUID).setValue(newCompleteHaikuDictionary)
                    }
                    
                }
                
                if let thirdUser = newCompleteHaiku.thirdPlayerUUID {
                    
                    if thirdUser != currentUserUID {
                        let thirdUserNewCompletedHaikusRef = newCompletedHaikusRef.child(thirdUser)
                        thirdUserNewCompletedHaikusRef.child(uniqueHaikuUUID).setValue(newCompleteHaikuDictionary)
                    }
                    
                }
            
            }
            
        })
        
    }
    
    static func getPlayerEmailFromUUID (_ uuid: String, closure: @escaping (String) -> Void) {
        
        
        profileRef.child(uuid).observeSingleEvent(of: .value, with: { (player) in
            
        let playerInfo = player.value as! NSDictionary
        let playerEmail = playerInfo.object(forKey: "email") as! String
            
        closure(playerEmail)
    })
    
    }
    
    static func getPlayerOneSignalIDFromUID (_ uid: String, closure: @escaping (String) -> Void) {
        
        oneSignalIDsRef.child(uid).observeSingleEvent(of: .value, with: { (oneSignalID) in
            
            if oneSignalID.exists() {
            
            print(oneSignalID)
            
            let oneSignalIDstring = oneSignalID.value as! String
            
            closure(oneSignalIDstring)
            } else {
                closure("no OneSignal ID for user")
            }
        })
    }

    

}
