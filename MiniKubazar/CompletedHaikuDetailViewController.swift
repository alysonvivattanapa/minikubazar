//
//  CompletedHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/11/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class CompletedHaikuDetailViewController: UIViewController {

    @IBOutlet weak var congratsLabel: UILabel!
    
    @IBOutlet weak var completedHaikuDetailImageView: UIImageView!
    
    @IBOutlet weak var kubazarMascot: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var createANewHaikuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let random = arc4random_uniform(8)
        
        switch random {
        case 0:
            congratsLabel.text = "Congrats! You're a poet."
            
        case 1:
            
            congratsLabel.text = "Awesome haiku!"
            
        case 2:
            
            congratsLabel.text = "Nice poetry there."
            
        case 3:
            
            congratsLabel.text = "Incredible!"
            
        case 4:
            
            congratsLabel.text = "Wow! Nice job."
            
        case 5:
            
            congratsLabel.text = "This is beautiful."
            
        case 6:
            
            congratsLabel.text = "What a haiku!"
            
        case 7:
            
            congratsLabel.text = "Superb."
            
        case 8:
            
            congratsLabel.text = "Stupendous!"
            
        default:
            
            congratsLabel.text = "Two thumbs up!"
        }
        
        animateButtons()

                // Do any additional setup after loading the view.
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
        
    }
    
    func animateButtons() {
        congratsLabel.transform = CGAffineTransformMakeScale(0.6, 0.6)
        
        shareButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        createANewHaikuButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        kubazarMascot.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        completedHaikuDetailImageView.transform =
            CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(1.6, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            self.congratsLabel.transform = CGAffineTransformIdentity
            
            self.kubazarMascot.transform = CGAffineTransformIdentity
            
            self.completedHaikuDetailImageView.transform = CGAffineTransformIdentity
            
            self.shareButton.transform = CGAffineTransformIdentity
            
            self.createANewHaikuButton.transform = CGAffineTransformIdentity
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        if let shareableHaikuImage = completedHaikuDetailImageView.image {
        let activityItemsArray = [shareableHaikuImage]
        let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
        presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createANewHaiku(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController?.selectedIndex = 1

    }
    
    
}
