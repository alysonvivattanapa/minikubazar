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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.CGColor
        segmentedControl.tintColor = kubazarDarkGreen

        self.segmentedControl.selectedSegmentIndex = 0

        myAccountView.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
       ClientService.getCurrentUser({ (user) in
        if let userEmail = user.email {
        self.currentlyLoggedInLabel.text = "You are currently logged in as \(userEmail)"
        } else {
            print("error getting current user's email set to label")
        }
        })
        
        
    }
    
    @IBAction func segmentedControlIndexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("first item selected")
            myAccountView.hidden = true
            aboutKubazarView.hidden = false
        case 1:
            print("second item selected")
            aboutKubazarView.hidden = true
            myAccountView.hidden = false
            
            
        default:
            break
        }
    }

    @IBAction func signOutButtonPressed(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
    
        
        print("sign out button pressed")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let welcomeVC = WelcomeViewController()
        appDelegate.window?.rootViewController = welcomeVC
        
    }
  

}
