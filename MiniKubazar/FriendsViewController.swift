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
        friendsTableView.register(friendsNib, forCellReuseIdentifier: "friendsCell")
        
       friendsEmailTextField.autocapitalizationType = .none
        
       friendsEmailTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
        

    
    @IBAction func addFriendButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        
        if let email = friendsEmailTextField.text {
            
            if isValidEmail(email) == true {
                
                print("this is a valid email")
                
                checkIfFriendIsAlreadyAdded(email)
                
            } else {
                
                 present(Alerts.showErrorMessage("Please enter a valid email."), animated: true, completion: nil)
            }
            
        }
        
    }
    
    func checkIfFriendIsAlreadyAdded(_ emailStri: String) {
        
        ClientService.getFriendEmailsForCurrentUser { (friendEmails) in
            
            if friendEmails.contains(emailStri) {
                
                self.present(Alerts.showErrorMessage("\(emailStri) is already added to your friends list. Try another friend."), animated: true, completion: nil)
                
            } else  {
                if self.checkIfUserIsTryingToAddSelfAsFriend(emailStri) == true {
                    self.present(Alerts.showErrorMessage("Sorry! You can't add yourself as a friend at this time :)"), animated: true, completion: nil)
                } else {
                  
                    self.checkIfFriendAlreadyUsesKubazar(emailStri)
                    
                }
            }
    }
    }
    
    
    
    func checkIfUserIsTryingToAddSelfAsFriend(_ emailStr: String) -> Bool {
        let currentUserEmail = ClientService.getCurrentUserEmail()
        if emailStr == currentUserEmail {

           return true
            
        } else {
            
            return false
    }
    }
    
    func checkIfFriendAlreadyUsesKubazar(_ emailStri: String) {
        
        //block only fires when snapshot exists
        
        ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: emailStri).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: emailStri).observeSingleEvent(of: .childAdded, with: { (friendSnapshot) in
                print("THIS IS THE PROFILE SNAPSHOT: \(snapshot)")
                print("THIS IS THE PROFILE SNAPSHOT.VALUE: \(snapshot.value)")
                
                let friend = friendSnapshot.value as! NSDictionary
                 
                let friendUID = friend.object(forKey: "uid") as! String
                    
                let friendEmail = friend.object(forKey: "email") as! String
                    
                let friendUsername = friend.object(forKey: "username") as! String
                    
//                let friendUID = (friendSnapshot.value as AnyObject).object(forKey: "uid") as! String
//                let friendEmail = (friendSnapshot.value as AnyObject).object(forKey: "email") as! String
//                let friendUsername = (friendSnapshot.value as AnyObject).object(forKey: "username") as! String
                
                print("\(friendEmail) & \(friendUID) & \(friendUsername)")
                
                let friendUser = User(username: friendUsername, email: friendEmail, uid: friendUID)
                
                print(friendUser)
                
                ClientService.addFriendToCurrentUserFriendsList(friendUser)
                
                self.present(Alerts.showSuccessMessage("\(emailStri) added to friends list. Add another friend."), animated: true, completion: nil)
                })
                
            } else {
                self.sendInvitationEmail(emailStri)
            }
            
            
        })

    
    }
    
    func isFriendAlreadyAdded(_ emailStri: String) {
        
        ClientService.getFriendEmailsForCurrentUser { (friendEmails) in
            let currentUserEmail = ClientService.getCurrentUserEmail()
            if friendEmails.contains(emailStri) {
                self.present(Alerts.showErrorMessage("\(emailStri) is already added to your friends list. Try another friend."), animated: true, completion: nil)
            } else if emailStri == currentUserEmail {
                //this is working!
                self.present(Alerts.showErrorMessage("Sorry! You can't add yourself as a friend at this time :)"), animated: true, completion: nil)
            } else if !friendEmails.contains(emailStri) {
                
                ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: emailStri).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        print("THIS IS THE PROFILE SNAPSHOT: \(snapshot)")
                        print("THIS IS THE PROFILE SNAPSHOT.VALUE: \(snapshot.value)")
                        
                        
                        let friendUID = (snapshot.value as AnyObject).object(forKey: "uid") as! String
                        let friendEmail = (snapshot.value as AnyObject).object(forKey: "email") as! String
                        let friendUsername = (snapshot.value as AnyObject).object(forKey: "username") as! String
                        
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


    
    func isValidEmail(_ emailStr: String) -> Bool {
        if emailStr.contains("@") {
            return true
        } else {
            return false
        }
    }

    
// invitation email to add non-users as friends

    func sendInvitationEmail(_ email: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Play Kubazar with me!")
            mail.setMessageBody("<p>Play Kubazar with me!</p>", isHTML: true)
            
           present(mail, animated: true, completion: nil)
            
        } else {
            
            present(Alerts.showErrorMessage("You aren't currently able to send an invitation email. Please try again later."), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) {
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
            
             OperationQueue.main.addOperation  {
                let friendUIDArray = arrayOfFriendUIDs
                
                self.friendsTableViewDataSource.friendArray = []
                
                for friendUID in friendUIDArray {
                    ClientService.profileRef.child("\(friendUID)").queryOrderedByKey().observe(.value, with: { (friend) in
                        print("FRIEND is \(friend)")
                        let uid = (friend.value! as AnyObject).object(forKey: "uid") as! String
                        let email = (friend.value! as AnyObject).object(forKey: "email") as! String
                        let username = (friend.value! as AnyObject).object(forKey: "username") as! String
                        let friend = User(username: username, email: email, uid: uid)
                        self.friendsTableViewDataSource.friendArray.append(friend)
                       
                        self.friendsTableView.reloadSections(IndexSet(integer: 0), with: .none)
                        
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        //adjust height later
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select: \((indexPath as NSIndexPath).row)")
    
    }
    
    
    
// MARK: keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillHide(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
// MARK: extraneous

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideInviteNewFriends()
    }
    
    // MARK: invite new friends views
    
    func showInviteFriends() {
        inviteNewFriendsView.isHidden = false
        inviteNewFriendsButton.isHidden = true
    }
    
    func hideInviteNewFriends() {
        inviteNewFriendsView.isHidden = true
        inviteNewFriendsButton.isHidden = false
    }
    
    
    
    @IBAction func xButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        friendsEmailTextField.text? = ""
        hideInviteNewFriends()
    }
    
    
    @IBAction func inviteNewFriendsButtonPressed(_ sender: AnyObject) {
        showInviteFriends()
    }
    
    

}
