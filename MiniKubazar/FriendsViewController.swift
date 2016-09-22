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
           
                switch isValidEmail(email) {
                    
                case true:
                    
                    checkIfFriendIsAlreadyAdded(email)
                    
                case false:
                
                presentViewController(Alerts.showErrorMessage("Please enter a valid email."), animated: true, completion: nil)
                    
                default:
                    
                    break
                }
    
            }
                
    }
    
    func checkIfFriendIsAlreadyAdded(emailStri: String) {
        
        ClientService.getFriendEmailsForCurrentUser { (friendEmails) in
            if friendEmails.contains(emailStri) {
                // this is working!
                self.presentViewController(Alerts.showErrorMessage("\(emailStri) is already added to your friends list. Try another friend."), animated: true, completion: nil)
            } else {
                //this is working!
                let currentUserEmail = ClientService.getCurrentUserEmail()
                if emailStri == currentUserEmail {
                    self.presentViewController(Alerts.showErrorMessage("Sorry! You can't add yourself as a friend at this time :)"), animated: true, completion: nil)
                } else {
                    
                    ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(emailStri).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                       
                        if snapshot.exists() {
                             print("THIS IS THE PROFILE SNAPSHOT: \(snapshot)")
                            print("THIS IS THE PROFILE SNAPSHOT.VALUE: \(snapshot.value)")
                            
                            // ISSUES HERE FIX THIS!!! EVERYTHING ELSE IS WORKING JUST NEED TO PROPERLY RETRIEVE FRIEND INFO, TURN TO USER OBJECT, ADD OBJECT TO FRIEND LIST.
                            let friendObject = snapshot.value
                            
//                            let friendEmail = friendObject?.objectForKey("email") as! String
//                            let username = friendObject?.objectForKey("username") as! String
//                            let uid = friendObject?.objectForKey("uid") as! String
//                            let friendUser = User(username: username, email: friendEmail, uid: uid)
//                            print(friendUser)
                            
                        } else {
                            //if snapshot is null, it means that friend is not an existing Kubazar user. if friend is not an existing Kubazar user, this code triggers an email invitation to friend to join Kubazar. 
                            // this code is working!!
                            print("THIS PROFILE SNAPSHOT DOES NOT EXIST: \(snapshot)")
                            self.sendInvitationEmail(emailStri)
                        }
                    })
                    
                }
            }
        }
    }

//    func addExistingUserAsFriend(snapshot: FDataSna?) {
//        
//    }
//    
    
//        all of these are working!!
//        let alysonEmail = "alyson.vivagmail.com"
//        if isValidEmail(alysonEmail) == true {
//            sendInvitationEmail(alysonEmail)
//        } else {
//            presentViewController(Alerts.showErrorMessage("Please enter a valid email address."), animated: true, completion: {
//                
//            })
//        }

//        sendInvitationEmail("alyson.viva@gmail.com")
//        presentViewController(Alerts.showErrorMessage("You aren't currently able to send an invitation email. Please try again later."), animated: true, completion: nil)
    
    

// check for valid email address
    
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
            if let friendsEmail = self.friendsEmailTextField.text {
                self.presentViewController(Alerts.showSuccessMessage("Email sent to \(friendsEmail). Invite another friend."), animated: true, completion: nil)
            }
            self.showInviteFriends()
            self.friendsEmailTextField.text = ""
        }
        
    }




    
// MARK: tableview
    
    func fetchFriendsAndSetToDataSource() {
        print ("fetch friends data gets called")
        
        ClientService.getFriendUIDsForCurrentUser { (arrayOfFriendUIDs) in
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
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
