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
    
    static let activeHaikusRef = rootRef.child("activeHaikus")
    
    static let completedHaikusRef = rootRef.child("completedHaikus")
    
    static let friendsRef = rootRef.child("friends")
    
    static let storage = FIRStorage.storage()
    
    static let storageRef = storage.reference(forURL: "gs://kubazar-2.appspot.com")
    
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
        
       activeHaikusRef.child("\(currentUserUid)").queryOrderedByKey().observe(.value, with: { snapshot in
            
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
            
            
            let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, secondPlayerUUID: secondPlayerUUID, thirdPlayerUUID: thirdPlayerUUID, uniqueHaikuUUID: uniqueHaikuUUID)
            
            arrayOfActiveHaikuObjects.append(newHaikuObject)
        }
        
         closure(arrayOfActiveHaikuObjects)
        
        })
    }
    
    
    static func getCompletedHaikuObjectsForCurrentUser(_ closure: @escaping ([ActiveHaiku]) -> Void) {
        
        let currentUserUid = getCurrentUserUID()
        
        newCompletedHaikusRef.child("\(currentUserUid)").queryOrderedByKey().observe(.value, with: { snapshot in
            
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
                
                
                let newHaikuObject = ActiveHaiku(firstLineString: firstLineString, secondLineString: secondLineString, thirdLineString: thirdLineString, imageURLString: imageURLString, firstPlayerUUID: firstPlayerUUID, secondPlayerUUID: secondPlayerUUID, thirdPlayerUUID: thirdPlayerUUID, uniqueHaikuUUID: uniqueHaikuUUID)
                
                arrayOfCompletedHaikuObjects.append(newHaikuObject)
            }
            
            closure(arrayOfCompletedHaikuObjects)
            
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
    
//    static func addActiveHaikuForSoloPlayer (_ activeHaiku: ActiveHaiku) {
//        
//    }
    
    static func addActiveHaikuForPlayers (_ activeHaiku: ActiveHaiku) {
        let currentUserUID = ClientService.getCurrentUserUID()
        let currentUserActiveHaikusRef = activeHaikusRef.child(currentUserUID)
        
        let firstLineString = activeHaiku.firstLineString
        let secondLineString = activeHaiku.secondLineString
        let thirdLineString = activeHaiku.thirdLineString
        let imageURLString = activeHaiku.imageURLString
        let firstPlayerUUID = activeHaiku.firstPlayerUUID
        let secondPlayerUUID = activeHaiku.secondPlayerUUID
        let thirdPlayerUUID = activeHaiku.thirdPlayerUUID
        let uniqueHaikuUUID = activeHaiku.uniqueHaikuUUID
        
        let activeHaikuDictionary: NSDictionary = ["firstLineString": firstLineString!, "secondLineString": secondLineString!, "thirdLineString": thirdLineString!, "imageURLString": imageURLString!, "firstPlayerUUID": firstPlayerUUID!, "secondPlayerUUID": secondPlayerUUID!, "thirdPlayerUUID": thirdPlayerUUID!, "uniqueHaikuUUID": uniqueHaikuUUID!]
        
        currentUserActiveHaikusRef.child(uniqueHaikuUUID!).setValue(activeHaikuDictionary)
        
        if currentUserUID != firstPlayerUUID {
            let firstPlayerActiveHaikusRef = activeHaikusRef.child(firstPlayerUUID!)
            firstPlayerActiveHaikusRef.child(uniqueHaikuUUID!).setValue(activeHaikuDictionary)
        }

        
        if currentUserUID != secondPlayerUUID {
            let secondPlayerActiveHaikusRef = activeHaikusRef.child(secondPlayerUUID!)
            secondPlayerActiveHaikusRef.child(uniqueHaikuUUID!).setValue(activeHaikuDictionary)
        }
        
        if currentUserUID != thirdPlayerUUID {
            let thirdPlayerActiveHaikusRef = activeHaikusRef.child(thirdPlayerUUID!)
            
            thirdPlayerActiveHaikusRef.child(uniqueHaikuUUID!).setValue(activeHaikuDictionary)
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
         
            let newCompleteHaiku = ActiveHaiku(firstLineString: firstLine, secondLineString: secondLine, thirdLineString: thirdLineTextString, imageURLString: imageURL, firstPlayerUUID: firstPlayer, secondPlayerUUID: secondPlayer, thirdPlayerUUID: thirdPlayer, uniqueHaikuUUID: uniqueHaikuUUID)
            
            let newCompleteHaikuDictionary: NSDictionary = ["firstLineString": newCompleteHaiku.firstLineString, "secondLineString": newCompleteHaiku.secondLineString, "thirdLineString": newCompleteHaiku.thirdLineString, "imageURLString": newCompleteHaiku.imageURLString, "firstPlayerUUID": newCompleteHaiku.firstPlayerUUID, "secondPlayerUUID": newCompleteHaiku.secondPlayerUUID, "thirdPlayerUUID": newCompleteHaiku.thirdPlayerUUID, "uniqueHaikuUUID": newCompleteHaiku.uniqueHaikuUUID]
            
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

    

}
