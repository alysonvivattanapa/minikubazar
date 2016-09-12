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
        case 1:
            print("second item selected")
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
