//
//  ActiveHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit



class ActiveHaikuDetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstLineTextView: UITextView!
    
    @IBOutlet weak var secondLineTextView: UITextView!
    
    @IBOutlet weak var thirdLineTextView: UITextView!
    
    var firstPlayerUUID: String?
    
    var secondPlayerUUID: String?
    
    var thirdPlayerUUID: String?
    
    var uniqueHaikuUUID: String?
    
    @IBOutlet weak var waitForOtherPlayersLabel: UILabel!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    let currentUserUID = ClientService.getCurrentUserUID()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uniqueUID = uniqueHaikuUUID {
            print(uniqueUID)
        }
        
        firstLineTextView.delegate = self
        secondLineTextView.delegate = self
        thirdLineTextView.delegate = self
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
   override func viewWillAppear(animated: Bool) {
    
    disableUserinteractionForAllTextViews()
    
    continueButton.hidden = true
    
    waitForOtherPlayersLabel.hidden = false
    
       print("DETAIL FIRST \(firstPlayerUUID)")
    print("DETAIL SECOND \(secondPlayerUUID)")
    print("DETAIL THIRD \(thirdPlayerUUID)")
    
    }
    

    
    func disableUserinteractionForAllTextViews() {
        firstLineTextView.userInteractionEnabled = false
        secondLineTextView.userInteractionEnabled = false
        thirdLineTextView.userInteractionEnabled = false
    }
    
    
    func hideContinueButtonAndLabel() {
        continueButton.hidden = true
        waitForOtherPlayersLabel.hidden = true
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        print("Active haiku detail view controller continue button pressed")
        
        if !secondLineTextView.text.containsString("enters second line of haiku") && !secondLineTextView.text.containsString("Waiting on second player") {
            
             ifSecondTextFieldWasEdited()
            
        }
        
        if !thirdLineTextView.text.containsString("enters second line, you can write third line") && !thirdLineTextView.text.containsString("after second player's turn") {
            
            ifThirdTextFieldWasEdited()
            
        }
        
    }
    
    func ifSecondTextFieldWasEdited() {
/*
        I think I fixed the bug that was causing Elisa and Anja's apps to crash. Theoretically, because the UI/UX hasn't been implemented in the flow yet, or because there was something weird about Firebase's realtime database, it would update the second line sometimes after the active haiku was already removed. To fix, I wrote an if statement that executes the code only when the snapshot exists for that path. So if the snapshot does not exist, that means that the active haiku was removed, and the code to update the second line shouldn't execute. (otherwise it adds a second line even though the active haiku has already been removed and then causes the app to crash because the existing path has incomplete child values.
        */
        
        if let haikuUniqeUUID = uniqueHaikuUUID, secondLineText = secondLineTextView.text {
            
            let updateDictionary = ["secondLineString": secondLineText]
            
            print(updateDictionary)
            
            ClientService.activeHaikusRef.child("\(currentUserUID)/\(haikuUniqeUUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
                
                print(snapshot)
                
                print(snapshot.exists())
                
                if snapshot.exists() {
                    
                    ClientService.activeHaikusRef.child("\(self.currentUserUID)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                    
                    let alertController = UIAlertController(title: "Success!", message: "You wrote a great second line.", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alertController.addAction(okayAction)
//                    alertController.modalPresentationStyle = .OverCurrentContext
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
//                    if (self.navigationController?.visibleViewController?.isKindOfClass(UIAlertController)) == true {
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                    }
                }})
                    
//                     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                    
//                    var rootViewController = appDelegate.keyW
//                    
//                    if (rootViewController is UINavigationController) {
//                        rootViewController = (rootViewController as! UINavigationController).viewControllers.first!
//                    }
//                    
//                    if (rootViewController is UITabBarController) {
//                        rootViewController = (rootViewController as! UITabBarController).selectedViewController!
//                    }
//                    
                    //this code is still being weird
                    
//                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(alertController, animated: true, completion: nil)
                    
        
            if let firstPlayer = firstPlayerUUID {
                if firstPlayer != currentUserUID {
                    ClientService.activeHaikusRef.child("\(firstPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
                        
                        if snapshot.exists() {
                            
                            ClientService.activeHaikusRef.child("\(firstPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                        }})
                }
            }
            
            
            if let secondPlayer = secondPlayerUUID {
                if secondPlayer != currentUserUID {
                    
                    ClientService.activeHaikusRef.child("\(secondPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
                        
                        if snapshot.exists() {
                            
                            ClientService.activeHaikusRef.child("\(secondPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                        }})
                }
            }
            
            
            
            
            if let thirdPlayer = thirdPlayerUUID {
                if thirdPlayer != currentUserUID {
                    
                    ClientService.activeHaikusRef.child("\(thirdPlayer)/\(haikuUniqeUUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
                        
                        if snapshot.exists() {
                            
                            ClientService.activeHaikusRef.child("\(thirdPlayer)/\(haikuUniqeUUID)").updateChildValues(updateDictionary)
                        }})
                }
            }
        }
    }
    
    func ifThirdTextFieldWasEdited() {
        
            print("THIS SHOULD BE TRIGGERED IF THIRD TEXT FIELD WAS EDITED")
        
            if let uniqueUUID = uniqueHaikuUUID, thirdLineText = thirdLineTextView.text {
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                 ClientService.fetchActiveHaikuAndMoveToNewCompletedHaikus(uniqueUUID, thirdLineTextString: thirdLineText)
                
                    ClientService.activeHaikusRef.child("\(self.currentUserUID)/\(uniqueUUID)").removeValue()
                
                if let firstPlayer = self.firstPlayerUUID {
                   if firstPlayer != self.currentUserUID {
                    ClientService.activeHaikusRef.child("\(firstPlayer)/\(uniqueUUID)").removeValue()
                    }
                }
                
                if let secondPlayer = self.secondPlayerUUID {
                    if secondPlayer != self.currentUserUID {
                        ClientService.activeHaikusRef.child("\(secondPlayer)/\(uniqueUUID)").removeValue()
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
}
