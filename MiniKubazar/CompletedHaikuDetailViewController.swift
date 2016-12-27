//
//  CompletedHaikuDetailViewController.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/11/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import MessageUI

class CompletedHaikuDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var flagView: UIView!
    
    @IBOutlet weak var completedHaikuDetailImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var firstLineLabel: UILabel!
    
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBOutlet weak var thirdLineLabel: UILabel!
    
    @IBOutlet weak var dotDotDotButton: UIButton!
    
    @IBOutlet weak var shareableView: UIView!
    
    @IBOutlet weak var playerIDButton: UIButton!
    
    
    var uniqueHaikuUUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagView.isHidden = true
        
        flagView.layer.cornerRadius = 15
        
        animateButtons()

                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        
    }
    
    func animateButtons() {
        
        shareButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        completedHaikuDetailImageView.transform =
            CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 1.6, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {

            self.completedHaikuDetailImageView.transform = CGAffineTransform.identity
            
            self.shareButton.transform = CGAffineTransform.identity
            
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
    
    @IBAction func dotDotDotButtonPressed(_ sender: AnyObject) {
        
         flagView.isHidden = false
    }
    
    @IBAction func flagReportButtonPressed(_ sender: AnyObject) {
        
        if let haikuID = uniqueHaikuUUID {
        
        sendFlagReportEmail(haikuID)
        }
    }
    
    
    func sendFlagReportEmail(_ haikuID: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ons@crowdeffect.nl"])
            mail.setSubject("[Flag/Report] Inappropriate Content re: Haiku ID# \(haikuID)")
            mail.setSubject(haikuID)
            mail.setMessageBody("<p>Please flag this haiku for inappropriate content.</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
            
        } else {
            
            present(Alerts.showErrorMessage("You aren't currently able to send an email through this app. Please directly email info@kubazar.org."), animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func dismissFlagReportButtonPressed(_ sender: AnyObject) {
        flagView.isHidden = true
    }

    @IBAction func playerIDButtonPressed(_ sender: Any) {
    }
    
    
}
