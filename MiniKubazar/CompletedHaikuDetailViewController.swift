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
    
    func animateButtons() {
        shareButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        createANewHaikuButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(1.6, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
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
