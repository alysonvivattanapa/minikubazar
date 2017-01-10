//
//  ActiveHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import MessageUI
import OneSignal


class ActiveHaikuDetailViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var haikuInputView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstLineTextView: UITextView!
    
    @IBOutlet weak var secondLineTextView: UITextView!
    
    @IBOutlet weak var thirdLineTextView: UITextView!
    
    @IBOutlet weak var flagReportView: UIView!
 
    @IBOutlet weak var flagReportButton: UIButton!
    
    
    var firstPlayerUUID: String?
    
    var secondPlayerUUID: String?
    
    var thirdPlayerUUID: String?
    
    var uniqueHaikuUUID: String?
    
    var firstPlayerEmail: String?
    
    var secondPlayerEmail: String?
    
    var thirdPlayerEmail: String?
    
    var turnCounterString: String?
    
    @IBOutlet weak var waitForOtherPlayersLabel: UILabel!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    @IBOutlet weak var playerIDButton: UIButton!
    
    @IBOutlet weak var firstPlayerEmailLabel: UILabel!
    
    @IBOutlet weak var secondPlayerEmailLabel: UILabel!
    
    @IBOutlet weak var thirdPlayerEmailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerEmailLabel.isHidden = true
        
        secondPlayerEmailLabel.isHidden = true
        
        thirdPlayerEmailLabel.isHidden = true
        
        ///IF LET TO UNWRAP
        
        if let firstPlayer = firstPlayerEmail {
            firstPlayerEmailLabel.text = firstPlayer
        }
        
        if let secondPlayer = secondPlayerEmail {
            secondPlayerEmailLabel.text = secondPlayer
        }
        
        if let thirdPlayer = thirdPlayerEmail {
            thirdPlayerEmailLabel.text = thirdPlayer
        }
        
        print("First player email is \(firstPlayerEmail)")
        
        print("Second player email is \(secondPlayerEmail)")
        
        print("Third player email is \(thirdPlayerEmail)")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reduceHaikuTextViewAlpha))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        flagReportView.isHidden = true
        flagReportView.layer.cornerRadius = 15
        
        if let uniqueUID = uniqueHaikuUUID {
            print(uniqueUID)
        }
        
        print(secondPlayerEmail)
        print(thirdPlayerEmail)
        
        firstLineTextView.delegate = self
        secondLineTextView.delegate = self
        thirdLineTextView.delegate = self
        
        firstLineTextView.textContainer.maximumNumberOfLines = 1
        firstLineTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        secondLineTextView.textContainer.maximumNumberOfLines = 1
        secondLineTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        thirdLineTextView.textContainer.maximumNumberOfLines = 1
        thirdLineTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func reduceHaikuTextViewAlpha() {
        if haikuInputView.alpha == 1 {
            haikuInputView.alpha = 0.3
        } else {
            haikuInputView.alpha = 1
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        waitForOtherPlayersLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .transitionCurlUp, animations: {
            self.waitForOtherPlayersLabel.transform = CGAffineTransform.identity
            
            
            }, completion: nil)
        
        if let secondPlayer = secondPlayerUUID {
            ClientService.getPlayerEmailFromUUID(secondPlayer, closure: { (playerEmail) in
                self.secondPlayerEmail = playerEmail
                print(self.secondPlayerEmail)
            })
            
        }
        
        if let thirdPlayer = thirdPlayerUUID {
            ClientService.getPlayerEmailFromUUID(thirdPlayer, closure: { (playerEmail) in
                self.thirdPlayerEmail = playerEmail
                print(self.thirdPlayerEmail)
            })
        }
        
    }
    
    @IBAction func popOutButtonPressed(_ sender: AnyObject) {
        let popOutVC = PopOutImageViewController()
        present(popOutVC, animated: true) {
            popOutVC.poppedOutImageView.image = self.imageView.image
        }
    }
    
    
    
    func disableUserinteractionForAllTextViews() {
        firstLineTextView.isUserInteractionEnabled = false
        secondLineTextView.isUserInteractionEnabled = false
        thirdLineTextView.isUserInteractionEnabled = false
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        
        print("Active haiku detail view controller continue button pressed")
        
        if let secondPlayer = secondPlayerEmail, let thirdPlayer = thirdPlayerEmail {
            if secondLineTextView.text != secondPlayer && self.turnCounterString == "1" {
                if thirdLineTextView.text == thirdPlayer {
                    ifSecondTextFieldWasEdited()
                }
            }
        }
        
        if let secondPlayer = secondPlayerEmail, let thirdPlayer = thirdPlayerEmail {
            
            if secondLineTextView.text != secondPlayer && self.turnCounterString == "2" {
                if thirdLineTextView.text != thirdPlayer {
                ifThirdTextFieldWasEdited()
                }
            }
        }
        
        
//        if let secondPlayer = secondPlayerEmail, let thirdPlayer = thirdPlayerEmail {
//            if !secondLineTextView.text.contains("enters second line of haiku") && (!secondLineTextView.text.contains("Waiting on second player") || !secondLineTextView.text.contains("\(secondPlayer) enters second line of haiku")) {
//                
//                if thirdLineTextView.text.contains("enters second line, you can write third line") || thirdLineTextView.text.contains("after second player's turn") || thirdLineTextView.text.contains("\(thirdPlayer) enters third line of haiku") {
//                    
//                    ifSecondTextFieldWasEdited()
//                }
//            }
//        }
//        
//        if let secondPlayer = secondPlayerEmail, let thirdPlayer = thirdPlayerEmail {
//            if !secondLineTextView.text.contains("enters second line of haiku") && !secondLineTextView.text.contains("Waiting on second player") && !secondLineTextView.text.contains("\(secondPlayer) enters second line of haiku") && !thirdLineTextView.text.contains("enters second line, you can write third line") && !thirdLineTextView.text.contains("after second player's turn") && !thirdLineTextView.text.contains("\(thirdPlayer) enters third line of haiku") {
//                
//                ifThirdTextFieldWasEdited()
//                
//            }
//        }
    }
    
    func ifSecondTextFieldWasEdited() {
        /*
         I think I fixed the bug that was causing Elisa and Anja's apps to crash. Theoretically, because the UI/UX hasn't been implemented in the flow yet, or because there was something weird about Firebase's realtime database, it would update the second line sometimes after the active haiku was already removed. To fix, I wrote an if statement that executes the code only when the snapshot exists for that path. So if the snapshot does not exist, that means that the active haiku was removed, and the code to update the second line shouldn't execute. (otherwise it adds a second line even though the active haiku has already been removed and then causes the app to crash because the existing path has incomplete child values.
         */
        
        if let haikuUniqeUUID = uniqueHaikuUUID, let secondLineText = secondLineTextView.text {
            
             let updateDictionary = ["secondLineString": secondLineText, "turnCounter": "2"]
            
//            let updateDictionary = ["secondLineString": secondLineText]
            
            print(updateDictionary)
            
            ClientService.activeHaikusRef.child("\(currentUserUID)/\(haikuUniqeUUID)").queryOrderedByKey().observe(.value, with: { snapshot in
                
                print(snapshot)
                
                print(snapshot.exists())
                
                if snapshot.exists() && snapshot.hasChild("firstLineString") {
                    
                    ClientService.activeHaikusRef.child("\(self.currentUserUID)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                    
                    let alertController = UIAlertController(title: "Success!", message: "You wrote a great second line.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: {
                        self.waitForOtherPlayersLabel.text = "Great job with that second line! Now wait for your friend to finish the haiku."
                        self.continueButton.isHidden = true
                        self.secondLineTextView.isUserInteractionEnabled = false
                        self.secondLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                        self.secondLineTextView.backgroundColor = UIColor.white
                    })
                    
                }})
            
            
            
            if let firstPlayer = firstPlayerUUID {
                if firstPlayer != currentUserUID {
                    OperationQueue.main.addOperation({
                        
                        ClientService.activeHaikusRef.child("\(firstPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observe(.value, with: { snapshot in
                            
                            if snapshot.exists() && snapshot.hasChild("firstLineString") {
                                
                                ClientService.activeHaikusRef.child("\(firstPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                            }})
                    })
                }
            }
            
            
            if let secondPlayer = secondPlayerUUID {
                if secondPlayer != currentUserUID {
                    
                    OperationQueue.main.addOperation({
                        
                        ClientService.activeHaikusRef.child("\(secondPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observe(.value, with: { snapshot in
                            
                            if snapshot.exists() && snapshot.hasChild("firstLineString") {
                                
                                ClientService.activeHaikusRef.child("\(secondPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                            }})
                    })
                }
            }
            
            if let thirdPlayer = thirdPlayerUUID {
                if thirdPlayer != currentUserUID {
                    
                    
                    
                    OperationQueue.main.addOperation({
                        
                        ClientService.activeHaikusRef.child("\(thirdPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observe(.value, with: { snapshot in
                            
                            if snapshot.exists() && snapshot.hasChild("firstLineString") {
                                
                                ClientService.activeHaikusRef.child("\(thirdPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                                
                            }})
                        
                        ClientService.getPlayerOneSignalIDFromUID(thirdPlayer, closure: { (oneSignalID) in
                            OneSignal.postNotification(["headings": ["en": "Your turn!"], "contents": ["en": "It's your turn. You can finish up a haiku!"], "ios_badgeType":"Increase", "ios_badgeCount": 1, "include_player_ids": [oneSignalID]])
                        })
                    })
                }
            }
        }
    }
    
    func ifThirdTextFieldWasEdited() {
        
        thirdLineTextView.backgroundColor = UIColor.white
        thirdLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        thirdLineTextView.isUserInteractionEnabled = false
        waitForOtherPlayersLabel.text = "Excellent haiku! You really created something special there."
        continueButton.isHidden = true
        
        let completedDetailView = CompletedHaikuDetailViewController()
        self.present(completedDetailView, animated: true) {
            if let firstLine = self.firstLineTextView.text, let secondLine = self.secondLineTextView.text, let haikuImage = self.imageView.image, let thirdLine = self.thirdLineTextView.text, let haikuUID = self.uniqueHaikuUUID {
                completedDetailView.completedHaikuDetailImageView.image = haikuImage
                completedDetailView.firstLineLabel.text = firstLine
                completedDetailView.secondLineLabel.text = secondLine
                completedDetailView.thirdLineLabel.text = thirdLine
                completedDetailView.uniqueHaikuUUID = haikuUID
            }
        }
        
        print("THIS SHOULD BE TRIGGERED IF THIRD TEXT FIELD WAS EDITED")
        
        if let uniqueUUID = uniqueHaikuUUID, let thirdLineText = thirdLineTextView.text {
            
            OperationQueue.main.addOperation({
                ClientService.fetchActiveHaikuAndMoveToNewCompletedHaikus(uniqueUUID, thirdLineTextString: thirdLineText)
                
                ClientService.activeHaikusRef.child("\(self.currentUserUID)/\(uniqueUUID)").removeValue()
                
                if let firstPlayer = self.firstPlayerUUID {
                    if firstPlayer != self.currentUserUID {
                        ClientService.activeHaikusRef.child("\(firstPlayer)/\(uniqueUUID)").removeValue()
                        
                        ClientService.getPlayerOneSignalIDFromUID(firstPlayer, closure: { (oneSignalID) in
                            OneSignal.postNotification(["headings": ["en": "Hooray!"], "contents": ["en": "Hooray! A haiku is complete. Check it out."], "ios_badgeType":"Increase", "ios_badgeCount": 1, "include_player_ids": [oneSignalID]])
                        })
                        
                    }
                }
                
                if let secondPlayer = self.secondPlayerUUID {
                    if secondPlayer != self.currentUserUID {
                        ClientService.activeHaikusRef.child("\(secondPlayer)/\(uniqueUUID)").removeValue()
                        
                        ClientService.getPlayerOneSignalIDFromUID(secondPlayer, closure: { (oneSignalID) in
                            OneSignal.postNotification(["headings": ["en": "Hooray!"], "contents": ["en": "Hooray! A haiku is complete. Check it out."], "ios_badgeType":"Increase", "ios_badgeCount": 1, "include_player_ids": [oneSignalID]])
                    })
                    
                }
                }
                
                if let thirdPlayer = self.thirdPlayerUUID {
                    if thirdPlayer != self.currentUserUID {
                        ClientService.activeHaikusRef.child("\(thirdPlayer)/\(uniqueUUID)").removeValue()
                    }
                }
            })
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = nil
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(red: 90.0/255, green: 191.0/255, blue: 188.0/255, alpha: 1)
        textView.clipsToBounds = true
    }
    
    @IBAction func dotDotDotButtonPressed(_ sender: AnyObject) {
        
        flagReportView.isHidden = false
    }

    
    @IBAction func flagReportButtonPressed(_ sender: AnyObject) {
        
        if let haikuUID = uniqueHaikuUUID {
            sendFlagReportEmail(haikuUID)
        }
        
        
        }
        
    
    func sendFlagReportEmail(_ haikuID: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ons@crowdeffect.nl"])
            mail.setSubject("[Flag/Report] Inappropriate Content re: Haiku ID# \(haikuID)")
            mail.setSubject(haikuID)
            mail.setMessageBody("<p>Please flag this haiku for inappropriate content.</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
            
        } else {
            
            present(Alerts.showErrorMessage("You aren't currently able to send an email through this app. Please directly email info@kubazar.org."), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func dismissFlagReportButtonPressed(_ sender: AnyObject) {
        flagReportView.isHidden = true
    }
    
    @IBAction func playerIDButtonPressed(_ sender: Any) {
        
        if firstPlayerEmailLabel.isHidden == true,
        
        secondPlayerEmailLabel.isHidden == true,
        
            thirdPlayerEmailLabel.isHidden == true {
        
        firstPlayerEmailLabel.isHidden = false
        
        secondPlayerEmailLabel.isHidden = false
        
        thirdPlayerEmailLabel.isHidden = false
            
        firstLineTextView.isHidden = true
            
        secondLineTextView.isHidden = true
            
        thirdLineTextView.isHidden = true
            
        } else {
            
            firstPlayerEmailLabel.isHidden = true
            
            secondPlayerEmailLabel.isHidden = true
            
            thirdPlayerEmailLabel.isHidden = true
            
            firstLineTextView.isHidden = false
            
            secondLineTextView.isHidden = false
            
            thirdLineTextView.isHidden = false
        }
        }
 
    
    
    
}
