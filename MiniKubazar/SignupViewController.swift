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
    
    var timer: Timer!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       
        
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
        
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.37, initialSpringVelocity: 6.7, options: .curveEaseIn, animations: {
            //    self.welcomeToKubazarLabel.center.y = originWelcomeY
            //    self.letsWriteHaikusTogetherLabel.center.y = originLetsWriteY
            self.kubazarImage.center.x = kubazarX
            //    self.createAccount.center.y = createAccountY
            //    self.signupEmailTextField.center.y = emailY
            //    self.signupPasswordTextField.center.y = passwordY
            //    self.firstContinueButton.center.y = continueY
            
            }, completion: nil)
        
        
    }

    

    
    override func viewWillAppear(_ animated: Bool) {
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async() {
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
            DispatchQueue.main.async() {
                print("Not reachable")
                let alert = UIAlertController(title: "Oops!", message: "Please connect to the internet to use Kubazar.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        
        
        self.firstViewAnimation()
        
    }
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
        // Dispose of any resources that can be recreated.
    }
    
    
    func isValidEmail(_ emailStr: String) -> Bool {
        if emailStr.contains("@") {
            return true
        } else {
            return false
        }
    }
    

    @IBAction func firstContinueButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        firstView.resignFirstResponder()
//        firstView.endEditing(true)
        
        if let text = signupEmailTextField.text , !text.isEmpty && isValidEmail(text) == true
        {
            let viewBoundsHeight = view.bounds.height
            let secondKubazarX = secondKubazarImage.center.x
            secondKubazarImage.center.x -= viewBoundsHeight
            
            self.firstView.alpha = 0
            self.secondView.alpha = 1
            
            UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.37, initialSpringVelocity: 6.7, options: .curveEaseIn, animations: {
               
                self.secondKubazarImage.center.x = secondKubazarX
                
                }, completion: nil)
            
        } else {
                
                
            self.present(Alerts.showErrorMessage("Please enter a valid email address."), animated: true, completion: nil)
        }
        
     
    }
    
  
    @IBAction func secondContinueButtonPressed(_ sender: AnyObject) {
        
    view.endEditing(true)
    createNewUser()
        
    }
    
    
    func createNewUser() {
        if let email = signupEmailTextField.text?.lowercased(), let password = signupPasswordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    self.present(Alerts.showErrorMessage((error?.localizedDescription)!), animated: true, completion: nil)
                    self.firstView.alpha = 1
                    self.secondView.alpha = 0
                    self.thirdView.alpha = 0
               
                } else {
                    
//                    let email = "user@example.com"
                    
                    FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {
                            self.present(Alerts.showErrorMessage(error.localizedDescription), animated: true, completion: nil)
                            return
                        }
                        print("Email verification sent.")
                    })
                    
                    FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
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
                        UIView.animate(withDuration: 1.5, animations: {
                          self.congratsKubazar.alpha = 0
                          self.congratsLabel.alpha = 0
                        }) 
                        
                    let animation = CABasicAnimation(keyPath: "transform.scale")
                        animation.toValue = NSNumber(value: 2.0 as Float)
                        animation.duration = 1.5
                        animation.autoreverses = false
                        self.congratsLabel.layer.add(animation, forKey: nil)
                        self.congratsKubazar.layer.add(animation, forKey: nil)
                        
                        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(SignupViewController.changeRootViewToTabBarController), userInfo: nil, repeats: false)

                }
                }
            })
            
        }
    }
    
    func changeRootViewToTabBarController() {
        
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

//        UIView.transitionFromView((appDelegate.window?.rootViewController?.view)! , toView: (appDelegate.tabBarController?.view)!, duration: 1.0, options: .TransitionCrossDissolve) { (Bool) in
//            appDelegate.window?.rootViewController = appDelegate.tabBarController
//            appDelegate.tabBarController?.selectedIndex = 0
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//        }
        
    
   
    func createNewUserProfile(_ uid: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthdate = dateFormatter.string(from: signupBirthdateDatePicker.date)
        
        let email = signupEmailTextField.text?.lowercased()
        
        let signupUsername = signupUsernameTextField.text?.lowercased()
        
        ClientService.profileRef.child("\(uid)/username").setValue(signupUsername)
        ClientService.profileRef.child("\(uid)/birthdate").setValue(birthdate)
        ClientService.profileRef.child("\(uid)/email").setValue(email)
        ClientService.profileRef.child("\(uid)/uid").setValue(uid)
        
    }
    

    
    @IBAction func firstViewBackButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        dismiss(animated: true, completion:  nil)
    }
    
    
    @IBAction func secondViewBackButtonPressed(_ sender: AnyObject) {
        view.endEditing(true)
        secondView.alpha = 0
        thirdView.alpha = 0
        firstView.alpha = 1
    }
    
    @IBAction func termsOfServiceAndPrivacyPolicy(_ sender: AnyObject) {
        
        let tosVC = TermsOfServiceViewController()
        present(tosVC, animated: true, completion: nil)
    }
  
    
}
