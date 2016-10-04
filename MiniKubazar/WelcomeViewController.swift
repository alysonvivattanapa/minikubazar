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

let reachability = Reachability()!

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var kubazarLogo: UIImageView!
    
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
       
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        let transformAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        transformAnimation.duration = 1
        transformAnimation.repeatCount = 1
        transformAnimation.autoreverses = false
        transformAnimation.fromValue = -180
        transformAnimation.toValue = 180
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards

    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let reachability = Reachability()!
        
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                
                let alert = UIAlertController(title: "Oops!", message: "Please connect to the internet to use Kubazar.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        

        
        kubazarLogo.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.37,
                                   initialSpringVelocity: 6.7,
                                   options: UIViewAnimationOptions.curveEaseIn,
                                   animations: {
                                    self.kubazarLogo.transform = CGAffineTransform.identity
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
        
        
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: CGFloat(0.9), initialSpringVelocity: CGFloat(6.7), options: .curveEaseIn, animations: {
            self.loginButton.center.y = originLoginY
            self.signupButton.center.y = originSignUpY
            self.emailTextField.center.y = originEmailY
            self.passwordTextField.center.y = originPasswordY
            }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.present( Alerts.showErrorMessage("Please enter your email & password."), animated: true, completion: nil)
            
            
        } else {
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                
                FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil {
//                        self.view.endEditing(true)
                        self.present(Alerts.showErrorMessage((error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
                }
            }
        }
    }


    @IBAction func signupButtonPressed(_ sender: AnyObject) {
                
        
        let signupVC = SignupViewController()
        signupVC.modalTransitionStyle = .crossDissolve
        
       present(signupVC, animated: true, completion: nil)
    }
    


    
}
