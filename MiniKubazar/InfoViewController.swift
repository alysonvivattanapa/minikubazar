
//
//  InfoViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class InfoViewController: UIViewController {
    
    @IBOutlet weak var myAccountView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var currentlyLoggedInLabel: UILabel!
   
    @IBOutlet weak var aboutKubazarView: UIView!
    
    @IBOutlet weak var howToPlayView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FOR NOW, HOW TO PLAY VIEW IS HIDDEN, BUT SHOULD EVENTUALLY BE ADDED TO ABOUT KUBAZAR SCROLL VIEW. SO YOU HAVE TO ADD A SCROLL VIEW.
        
        howToPlayView.isHidden = true
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.cgColor
        segmentedControl.tintColor = kubazarDarkGreen

        self.segmentedControl.selectedSegmentIndex = 0

        myAccountView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      
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
        
        
       ClientService.getCurrentUser({ (user) in
        if let userEmail = user.email {
        self.currentlyLoggedInLabel.text = "You are currently logged in as \(userEmail)"
        } else {
            print("error getting current user's email set to label")
        }
        })
        
        
    }
    
    @IBAction func segmentedControlIndexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("first item selected")
            myAccountView.isHidden = true
            aboutKubazarView.isHidden = false
        case 1:
            print("second item selected")
            aboutKubazarView.isHidden = true
            myAccountView.isHidden = false
            
            
        default:
            break
        }
    }

    @IBAction func signOutButtonPressed(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
    
        
        print("sign out button pressed")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let welcomeVC = WelcomeViewController()
        appDelegate.window?.rootViewController = welcomeVC
        
    }
    
    @IBAction func termsOfServiceButtonPressed(_ sender: AnyObject) {
        
        let tosVC = TermsOfServiceViewController()
        present(tosVC, animated: true, completion: nil)
    }
    
  

}
