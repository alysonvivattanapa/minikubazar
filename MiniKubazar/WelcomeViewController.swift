//
//  WelcomeViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var reachability: Reachability?

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var kubazarLogo: UIImageView!
    
    var timer = NSTimer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WelcomeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WelcomeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    

    
    override func viewDidAppear(animated: Bool) {
        
        let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        transformAnimation.duration = 1
        transformAnimation.repeatCount = 1
        transformAnimation.autoreverses = false
        transformAnimation.fromValue = -180
        transformAnimation.toValue = 180
        transformAnimation.removedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards

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
        

        
        kubazarLogo.transform = CGAffineTransformMakeScale(2, 2)
        
        UIView.animateWithDuration(2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.37,
                                   initialSpringVelocity: 6.7,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {
                                    self.kubazarLogo.transform = CGAffineTransformIdentity
            },
                                   completion: { Void in()  }
        )
        
        let originEmailY = emailTextField.center.y
        emailTextField.center.y -= view.bounds.height
        
        let originPasswordY = self.passwordTextField.center.y
        passwordTextField.center.y -= view.bounds.height
        
        let originLoginY = self.loginButton.center.y
        loginButton.center.y -= view.bounds.height
        
        let originSignUpY = self.signupButton.center.y
        signupButton.center.y -= view.bounds.height
        
        
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: CGFloat(0.9), initialSpringVelocity: CGFloat(6.7), options: .CurveEaseIn, animations: {
            self.loginButton.center.y = originLoginY
            self.signupButton.center.y = originSignUpY
            self.emailTextField.center.y = originEmailY
            self.passwordTextField.center.y = originPasswordY
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
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
           self.presentViewController( Alerts.showErrorMessage("Please enter your email & password."), animated: true, completion: nil)
            
           
        } else {
        
        if let email = emailTextField.text, password = passwordTextField.text {
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            
            if error != nil {
            self.presentViewController(Alerts.showErrorMessage((error?.localizedDescription)!), animated: true, completion: nil)
            } else {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.tabBarController?.viewControllers?.removeAll()
            let firstTab = BazarViewController(nibName: "BazarViewController", bundle: nil)
            let secondTab = StartViewController(nibName: "StartViewController", bundle: nil)
            let thirdTab = InfoViewController(nibName: "InfoViewController", bundle: nil)
            let controllers = [firstTab, secondTab, thirdTab]
            appDelegate.tabBarController?.viewControllers = controllers
            
            UITabBar.appearance().tintColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                
            firstTab.tabBarItem = UITabBarItem(title: "Bazar", image: UIImage(named: "bazarA"), selectedImage: UIImage(named: "bazarB"))
                
            secondTab.tabBarItem = UITabBarItem(title: "Start", image: UIImage(named: "startA"), selectedImage: UIImage(named: "startB"))
                
            thirdTab.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "infoA"), selectedImage: UIImage(named: "infoB"))


            appDelegate.window?.rootViewController = appDelegate.tabBarController
            appDelegate.tabBarController?.selectedIndex = 0
            }
        }
        }
        }
    }


    @IBAction func signupButtonPressed(sender: AnyObject) {
                
        
        let signupVC = SignupViewController()
        signupVC.modalTransitionStyle = .CrossDissolve
        
       presentViewController(signupVC, animated: true, completion: nil)
    }
    


    
}
