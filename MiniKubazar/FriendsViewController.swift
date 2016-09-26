//
//  FriendsViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import MessageUI

class FriendsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var xButton: UIButton!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var inviteNewFriendsView: UIView!
    
    @IBOutlet weak var friendsEmailTextField: UITextField!

    @IBOutlet weak var inviteNewFriendsButton: UIButton!
    
    let friendsTableViewDataSource = FriendsTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteNewFriendsView.layer.cornerRadius = 33
        
        friendsTableView.dataSource = friendsTableViewDataSource
        friendsTableView.delegate = self
        friendsTableView.allowsSelection = true
        
        fetchFriendsAndSetToDataSource()
        
        let friendsNib = UINib.init(nibName: "FriendsTableViewCell", bundle: nil)
        friendsTableView.registerNib(friendsNib, forCellReuseIdentifier: "friendsCell")
        
       friendsEmailTextField.autocapitalizationType = .None
        
       friendsEmailTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
        

    
    @IBAction func addFriendButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        
        if let email = friendsEmailTextField.text {
            
            if isValidEmail(email) == true {
                
                print("this is a valid email")
                
                checkIfFriendIsAlreadyAdded(email)
                
            } else {
                
                 presentViewController(Alerts.showErrorMessage("Please enter a valid email."), animated: true, completion: nil)
            }
            
        }
        
    }
    
    func checkIfFriendIsAlreadyAdded(emailStri: String) {
        
        ClientService.getFriendEmailsForCurrentUser { (friendEmails) in
            
            if friendEmails.contains(emailStri) {
                
                self.presentViewController(Alerts.showErrorMessage("\(emailStri) is already added to your friends list. Try another friend."), animated: true, completion: nil)
                
            } else  {
                if self.checkIfUserIsTryingToAddSelfAsFriend(emailStri) == true {
                    self.presentViewController(Alerts.showErrorMessage("Sorry! You can't add yourself as a friend at this time :)"), animated: true, completion: nil)
                } else {
                  
                    self.checkIfFriendAlreadyUsesKubazar(emailStri)
                    
                }
            }
    }
    }
    
    
    
    func checkIfUserIsTryingToAddSelfAsFriend(emailStr: String) -> Bool {
        let currentUserEmail = ClientService.getCurrentUserEmail()
        if emailStr == currentUserEmail {

           return true
            
        } else {
            
            return false
    }
    }
    
    func checkIfFriendAlreadyUsesKubazar(emailStri: String) {
        
        //block only fires when snapshot exists
        
        ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(emailStri).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.exists() {
                
                ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(emailStri).observeSingleEventOfType(.ChildAdded, withBlock: { (friendSnapshot) in
                print("THIS IS THE PROFILE SNAPSHOT: \(snapshot)")
                print("THIS IS THE PROFILE SNAPSHOT.VALUE: \(snapshot.value)")
                
                let friendUID = friendSnapshot.value?.objectForKey("uid") as! String
                let friendEmail = friendSnapshot.value?.objectForKey("email") as! String
                let friendUsername = friendSnapshot.value?.objectForKey("username") as! String
                
                print("\(friendEmail) & \(friendUID) & \(friendUsername)")
                
                let friendUser = User(username: friendUsername, email: friendEmail, uid: friendUID)
                
                print(friendUser)
                
                ClientService.addFriendToCurrentUserFriendsList(friendUser)
                
                self.presentViewController(Alerts.showSuccessMessage("\(emailStri) added to friends list. Add another friend."), animated: true, completion: nil)
                })
                
            } else {
                self.sendInvitationEmail(emailStri)
            }
            
            
        })

    
    }
    
    func isFriendAlreadyAdded(emailStri: String) {
        
        ClientService.getFriendEmailsForCurrentUser { (friendEmails) in
            let currentUserEmail = ClientService.getCurrentUserEmail()
            if friendEmails.contains(emailStri) {
                self.presentViewController(Alerts.showErrorMessage("\(emailStri) is already added to your friends list. Try another friend."), animated: true, completion: nil)
            } else if emailStri == currentUserEmail {
                //this is working!
                self.presentViewController(Alerts.showErrorMessage("Sorry! You can't add yourself as a friend at this time :)"), animated: true, completion: nil)
            } else if !friendEmails.contains(emailStri) {
                
                ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(emailStri).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                    
                    if snapshot.exists() {
                        print("THIS IS THE PROFILE SNAPSHOT: \(snapshot)")
                        print("THIS IS THE PROFILE SNAPSHOT.VALUE: \(snapshot.value)")
                        
                        
                        let friendUID = snapshot.value?.objectForKey("uid") as! String
                        let friendEmail = snapshot.value?.objectForKey("email") as! String
                        let friendUsername = snapshot.value?.objectForKey("username") as! String
                        
                        print("\(friendEmail) & \(friendUID) & \(friendUsername)")
                        
                        let friendUser = User(username: friendUsername, email: friendEmail, uid: friendUID)
                        
                        print(friendUser)
                        
                        ClientService.addFriendToCurrentUserFriendsList(friendUser)
                        
                    } else {
                        self.sendInvitationEmail(emailStri)
                    }
                })
                
            }
            
        }
    }


    
    func isValidEmail(emailStr: String) -> Bool {
        if emailStr.containsString("@") {
            return true
        } else {
            return false
        }
    }

    
// invitation email to add non-users as friends

    func sendInvitationEmail(email: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Play Kubazar with me!")
            mail.setMessageBody("<p>Play Kubazar with me!</p>", isHTML: true)
            
           presentViewController(mail, animated: true, completion: nil)
            
        } else {
            
            presentViewController(Alerts.showErrorMessage("You aren't currently able to send an invitation email. Please try again later."), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true) {
//            if let friendsEmail = self.friendsEmailTextField.text {
//                self.presentViewController(Alerts.showSuccessMessage("Email sent to \(friendsEmail). Invite another friend."), animated: true, completion: nil)
//            }
            self.showInviteFriends()
            self.friendsEmailTextField.text = ""
        }
        
    }




    
// MARK: tableview
    
    func fetchFriendsAndSetToDataSource() {
        print ("fetch friends data gets called")
        
        ClientService.getFriendUIDsForCurrentUser { (arrayOfFriendUIDs) in
            
             NSOperationQueue.mainQueue().addOperationWithBlock  {
                let friendUIDArray = arrayOfFriendUIDs
                
                self.friendsTableViewDataSource.friendArray = []
                
                for friendUID in friendUIDArray {
                    ClientService.profileRef.child("\(friendUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { (friend) in
                        print("FRIEND is \(friend)")
                        let uid = friend.value!.objectForKey("uid") as! String
                        let email = friend.value!.objectForKey("email") as! String
                        let username = friend.value!.objectForKey("username") as! String
                        let friend = User(username: username, email: email, uid: uid)
                        self.friendsTableViewDataSource.friendArray.append(friend)
                       
                        self.friendsTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                        
                    })
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
        //adjust height later
    }
    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select: \(indexPath.row)")
    
    }
    
    
    
// MARK: keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    
// MARK: extraneous

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        hideInviteNewFriends()
    }
    
    // MARK: invite new friends views
    
    func showInviteFriends() {
        inviteNewFriendsView.hidden = false
        inviteNewFriendsButton.hidden = true
    }
    
    func hideInviteNewFriends() {
        inviteNewFriendsView.hidden = true
        inviteNewFriendsButton.hidden = false
    }
    
    
    
    @IBAction func xButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        friendsEmailTextField.text? = ""
        hideInviteNewFriends()
    }
    
    
    @IBAction func inviteNewFriendsButtonPressed(sender: AnyObject) {
        showInviteFriends()
    }
    
    

}
