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
    
//    var haiku: ActiveHaiku!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLineTextView.delegate = self
        secondLineTextView.delegate = self
        thirdLineTextView.delegate = self
        
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveHaikuDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
//        print(haiku)

        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(animated: Bool) {
    
    disableUserinteractionForAllTextViews()
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    if let firstPlayer = firstPlayerUUID {
        print("FIRST PLAYER = \(firstPlayer)")
        if currentUserUID == firstPlayer {
            firstLineTextView.userInteractionEnabled = true
        }
    }
    
    if let secondPlayer = secondPlayerUUID {
        if currentUserUID == secondPlayer {
          secondLineTextView.userInteractionEnabled = true
        }
    }
    
    if let thirdPlayer = thirdPlayerUUID {
        if currentUserUID == thirdPlayer {
            thirdLineTextView.userInteractionEnabled = true
        }
    }
    print("DETAIL FIRST \(firstPlayerUUID)")
    print("DETAIL SECOND \(secondPlayerUUID)")
    print("DETAIL THIRD \(thirdPlayerUUID)")
    }
    
    func disableUserinteractionForAllTextViews() {
        firstLineTextView.userInteractionEnabled = false
        secondLineTextView.userInteractionEnabled = false
        thirdLineTextView.userInteractionEnabled = false
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


}
