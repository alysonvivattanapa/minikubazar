//
//  SignupViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var welcomeToKubazarLabel: UILabel!
    
    @IBOutlet weak var letsWriteHaikusTogetherLabel: UILabel!
    
    @IBOutlet weak var kubazarImage: UIImageView!
    
    
    @IBOutlet weak var secondKubazarImage: UIImageView!
    
    @IBOutlet weak var createAccount: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var signupEmailTextField: UITextField!
    
    @IBOutlet weak var signupUsernameTextField: UITextField!
    
    @IBOutlet weak var signupBirthdateDatePicker: UIDatePicker!
    
    @IBOutlet weak var signupPasswordTextField: UITextField!
    
    
    @IBOutlet weak var firstContinueButton: UIButton!
    
    var timer: NSTimer!
    
    @IBOutlet weak var congratsKubazar: UIImageView!
    
    
    @IBOutlet weak var congratsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        secondView.alpha = 0
        
        thirdView.alpha = 0
        
        firstView.alpha = 1
        
        signupEmailTextField.delegate = self
        
        signupUsernameTextField.delegate = self
        
        signupPasswordTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WelcomeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WelcomeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
       
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                
                let alert = UIAlertController(title: "Oops!", message: "Please connect to the internet to use Kubazar.", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okayAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        firstViewAnimation()
        
    }
    
    func firstViewAnimation() {
        
    let viewBoundsHeight = view.bounds.height
        
//    let originWelcomeY = welcomeToKubazarLabel.center.y
//    welcomeToKubazarLabel.center.y -= view.bounds.height
//        
//   
        
//    let originLetsWriteY = letsWriteHaikusTogetherLabel.center.y
//    letsWriteHaikusTogetherLabel.center.y -= viewBoundsHeight
        
    let kubazarX = kubazarImage.center.x
    kubazarImage.center.x -= viewBoundsHeight
//        
//    let createAccountY = createAccount.center.y
//    createAccount.center.y -= viewBoundsHeight
//
//    let emailY = signupEmailTextField.center.y
//    signupEmailTextField.center.y -= viewBoundsHeight
//        
//    let passwordY = signupPasswordTextField.center.y
//    signupPasswordTextField.center.y -= viewBoundsHeight
//        
//    let continueY = firstContinueButton.center.y
//    firstContinueButton.center.y -= viewBoundsHeight
    
    UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.37, initialSpringVelocity: 6.7, options: .CurveEaseIn, animations: {
//    self.welcomeToKubazarLabel.center.y = originWelcomeY
//    self.letsWriteHaikusTogetherLabel.center.y = originLetsWriteY
    self.kubazarImage.center.x = kubazarX
//    self.createAccount.center.y = createAccountY
//    self.signupEmailTextField.center.y = emailY
//    self.signupPasswordTextField.center.y = passwordY
//    self.firstContinueButton.center.y = continueY
    
    }, completion: nil)
    
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func isValidEmail(emailStr: String) -> Bool {
        if emailStr.containsString("@") {
            return true
        } else {
            return false
        }
    }
    

    @IBAction func firstContinueButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        firstView.resignFirstResponder()
//        firstView.endEditing(true)
        
        if let text = signupEmailTextField.text where !text.isEmpty && isValidEmail(text) == true
        {
            let viewBoundsHeight = view.bounds.height
            let secondKubazarX = secondKubazarImage.center.x
            secondKubazarImage.center.x -= viewBoundsHeight
            
            self.firstView.alpha = 0
            self.secondView.alpha = 1
            
            UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.37, initialSpringVelocity: 6.7, options: .CurveEaseIn, animations: {
               
                self.secondKubazarImage.center.x = secondKubazarX
                
                }, completion: nil)
            
        } else {
                
                
            self.presentViewController(Alerts.showErrorMessage("Please enter a valid email address."), animated: true, completion: nil)
        }
        
     
    }
    
  
    @IBAction func secondContinueButtonPressed(sender: AnyObject) {
        
    view.endEditing(true)
    createNewUser()
        
    }
    
    
    func createNewUser() {
        if let email = signupEmailTextField.text?.lowercaseString, password = signupPasswordTextField.text {
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                
                if error != nil {
                    self.presentViewController(Alerts.showErrorMessage((error?.localizedDescription)!), animated: true, completion: nil)
                    self.firstView.alpha = 1
                    self.secondView.alpha = 0
                    self.thirdView.alpha = 0
               
                } else {
                    
//                    let email = "user@example.com"
                    
                    FIRAuth.auth()?.currentUser?.sendEmailVerificationWithCompletion({ (error) in
                        if let error = error {
                            self.presentViewController(Alerts.showErrorMessage(error.localizedDescription), animated: true, completion: nil)
                            return
                        }
                        print("Email verification sent.")
                    })
                    
                    FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
                        if error != nil {
                            //error
                        } else {
                            // Password reset email sent.
                        }
                    }
                    
//                    self.secondView.endEditing(true)
                    self.secondView.alpha = 0
                    self.thirdView.alpha = 1
                   
                    if let currentUser = user?.uid {
                    self.createNewUserProfile(currentUser)
                        
                    self.congratsKubazar.alpha = 1
                    self.congratsLabel.alpha = 1
                        UIView.animateWithDuration(1.5) {
                          self.congratsKubazar.alpha = 0
                          self.congratsLabel.alpha = 0
                        }
                        
                    let animation = CABasicAnimation(keyPath: "transform.scale")
                        animation.toValue = NSNumber(float: 2.0)
                        animation.duration = 1.5
                        animation.autoreverses = false
                        self.congratsLabel.layer.addAnimation(animation, forKey: nil)
                        self.congratsKubazar.layer.addAnimation(animation, forKey: nil)
                        
                        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(SignupViewController.changeRootViewToTabBarController), userInfo: nil, repeats: false)

                }
                }
            })
            
        }
    }
    
    func changeRootViewToTabBarController() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController?.viewControllers?.removeAll()
        
        let firstTab = BazarViewController(nibName: "BazarViewController", bundle: nil)
        let secondTab = StartViewController(nibName: "StartViewController", bundle: nil)
        let thirdTab = FriendsViewController(nibName: "FriendsViewController", bundle: nil)
        let fourthTab = InfoViewController(nibName: "InfoViewController", bundle: nil)
        let controllers = [firstTab, secondTab, thirdTab, fourthTab]
        
        appDelegate.tabBarController?.viewControllers = controllers
        
        UITabBar.appearance().tintColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        firstTab.tabBarItem = UITabBarItem(title: "Bazar", image: UIImage(named: "bazarA"), selectedImage: UIImage(named: "bazarB"))
        
        secondTab.tabBarItem = UITabBarItem(title: "Start", image: UIImage(named: "startA"), selectedImage: UIImage(named: "startB"))
        
        thirdTab.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friendsA"), selectedImage: UIImage(named: "friendsB"))
        
        fourthTab.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "infoA"), selectedImage: UIImage(named: "infoB"))
        
        appDelegate.window?.rootViewController = appDelegate.tabBarController
        appDelegate.tabBarController?.selectedIndex = 0
    }

//        UIView.transitionFromView((appDelegate.window?.rootViewController?.view)! , toView: (appDelegate.tabBarController?.view)!, duration: 1.0, options: .TransitionCrossDissolve) { (Bool) in
//            appDelegate.window?.rootViewController = appDelegate.tabBarController
//            appDelegate.tabBarController?.selectedIndex = 0
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//        }
        
    
   
    func createNewUserProfile(uid: String) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthdate = dateFormatter.stringFromDate(signupBirthdateDatePicker.date)
        
        let email = signupEmailTextField.text?.lowercaseString
        
        let signupUsername = signupUsernameTextField.text?.lowercaseString
        
        ClientService.profileRef.child("\(uid)/username").setValue(signupUsername)
        ClientService.profileRef.child("\(uid)/birthdate").setValue(birthdate)
        ClientService.profileRef.child("\(uid)/email").setValue(email)
        ClientService.profileRef.child("\(uid)/uid").setValue(uid)
        
    }
    

    
    @IBAction func firstViewBackButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion:  nil)
    }
    
    
    @IBAction func secondViewBackButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        secondView.alpha = 0
        thirdView.alpha = 0
        firstView.alpha = 1
    }
    
  
    
}
