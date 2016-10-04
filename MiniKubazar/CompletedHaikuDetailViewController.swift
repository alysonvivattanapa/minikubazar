//
//  CompletedHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/11/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class CompletedHaikuDetailViewController: UIViewController {

//    @IBOutlet weak var congratsLabel: UILabel!
    
    @IBOutlet weak var completedHaikuDetailImageView: UIImageView!
    
//    @IBOutlet weak var kubazarMascot: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var firstLineLabel: UILabel!
    
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBOutlet weak var thirdLineLabel: UILabel!
    
    
    @IBOutlet weak var shareableView: UIView!
    
//    @IBOutlet weak var createANewHaikuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let random = arc4random_uniform(8)
//        
//        switch random {
//        case 0:
//            congratsLabel.text = "Congrats! You're a poet."
//            
//        case 1:
//            
//            congratsLabel.text = "Awesome haiku!"
//            
//        case 2:
//            
//            congratsLabel.text = "Nice poetry there."
//            
//        case 3:
//            
//            congratsLabel.text = "Incredible!"
//            
//        case 4:
//            
//            congratsLabel.text = "Wow! Nice job."
//            
//        case 5:
//            
//            congratsLabel.text = "This is beautiful."
//            
//        case 6:
//            
//            congratsLabel.text = "What a haiku!"
//            
//        case 7:
//            
//            congratsLabel.text = "Superb."
//            
//        case 8:
//            
//            congratsLabel.text = "Stupendous!"
//            
//        default:
//            
//            congratsLabel.text = "Two thumbs up!"
//        }
        
        animateButtons()

                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let reachability = Reachability()!
        
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
        }
        
//        do {
//            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch {
//            print("Unable to create Reachability")
//            return
//        }
//        
//        reachability!.whenReachable = { reachability in
//            // this is called on a background thread, but UI updates must
//            // be on the main thread, like this:
//            DispatchQueue.main.async {
//                if reachability.isReachableViaWiFi() {
//                    print("Reachable via WiFi")
//                } else {
//                    print("Reachable via Cellular")
//                }
//            }
//        }
//        
//        reachability!.whenUnreachable = { reachability in
//            // this is called on a background thread, but UI updates must
//            // be on the main thread, like this:
//            DispatchQueue.main.async {
//                print("Not reachable")
//                
//                let alert = UIAlertController(title: "Oops!", message: "Please connect to the internet to use Kubazar.", preferredStyle: .alert)
//                let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//                
//            }
//        }
//        
//        do {
//            try reachability!.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
        
    }
    
    func animateButtons() {
//        congratsLabel.transform = CGAffineTransformMakeScale(0.6, 0.6)
        
        shareButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
//        createANewHaikuButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
//        kubazarMascot.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        completedHaikuDetailImageView.transform =
            CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 1.6, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
//            self.congratsLabel.transform = CGAffineTransformIdentity
            
//            self.kubazarMascot.transform = CGAffineTransformIdentity
            
            self.completedHaikuDetailImageView.transform = CGAffineTransform.identity
            
            self.shareButton.transform = CGAffineTransform.identity
            
//            self.createANewHaikuButton.transform = CGAffineTransformIdentity
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        
        let shareableHaikuImage = createShareableHaikuImage()
        let activityItemsArray = [shareableHaikuImage]
        let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        
    }
    
    
    func createShareableHaikuImage() -> UIImage {
        
        var shareableHaikuImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(shareableView.bounds.size, false, UIScreen.main.scale)
        
    shareableView.drawHierarchy(in: shareableView.bounds, afterScreenUpdates: true)
        
        shareableHaikuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return shareableHaikuImage
        
    }
    
//    
//    @IBAction func createANewHaiku(sender: AnyObject) {
//    
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.tabBarController?.selectedIndex = 1
//        
//        dismissViewControllerAnimated(true, completion: nil)
//
//    }
    
    
}
