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
    
    static let storageRef = storage.referenceForURL("gs://minikubazar.appspot.com")
    
    static let imagesRef = storageRef.child("images")
    
    
    static func getCurrentUser(closure: (FIRUser) -> Void) {
        
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
    
    
    static func getFriendUIDsForCurrentUser(closure: [String] -> Void) {
        
        let currentUserUiD = getCurrentUserUID()
        
        friendsRef.child("\(currentUserUiD)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
            
            var arrayOfFriendUIDs = [String]()
            
            for item in snapshot.children {
                
                let friendUID = item.value.objectForKey("uid") as! String
                
                arrayOfFriendUIDs.append(friendUID)
            }
            
            closure(arrayOfFriendUIDs)
            
        })
        
    }
    
    static func getCompletedHaikuImageURLStringsForCurrentUser(closure: [String] -> Void) {
        
        let currentUserUid = getCurrentUserUID()
        
        completedHaikusRef.child("\(currentUserUid)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
            
            var arrayOfCompletedHaikuImageURLStrings = [String]()
            
            for item in snapshot.children {
                
                let completedHaikuImageURLString = item.value.objectForKey("imageURLString") as! String
                
                arrayOfCompletedHaikuImageURLStrings.append(completedHaikuImageURLString)
                
            }
            
            closure(arrayOfCompletedHaikuImageURLStrings)
            
        })
        
    }
    
    static func getFriendEmailsForCurrentUser(closure: [String] -> Void) {
        
        let currentUserUiD = getCurrentUserUID()
        
        friendsRef.child("\(currentUserUiD)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
            
            var friendEmails = [String]()
            
            for item in snapshot.children {
                
                let friendEmail = item.value.objectForKey("email") as! String
                
                friendEmails.append(friendEmail)
            }
            
            //             print(users)
            
            closure(friendEmails)
            
        })
        
    }

    static func addFriendToCurrentUserFriendsList (friend: User) {
        let currentUserUID = ClientService.getCurrentUserUID()
        let currentUserFriendsRef = friendsRef.child(currentUserUID)
        
        let uid = friend.uid
        let email = friend.email
        let username = friend.username
        
        let userDictionary: NSDictionary = ["uid": uid!, "email": email, "username": username]
        
        currentUserFriendsRef.child(uid).setValue(userDictionary)
        
    }

}