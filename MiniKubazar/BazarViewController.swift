//
//  BazarViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import FirebaseStorage

class BazarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var activeView: UIView!
    
    
    @IBOutlet weak var noHaikusView: UIView!
   
    
    @IBOutlet weak var completedView: UIView!
    
    @IBOutlet weak var completedHaikusCollectionView: UICollectionView!
    
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var startHaikuButton: UIButton!
    
    @IBOutlet weak var kubazarMascot: UIImageView!
    
    
    let completedCollectionViewDataSource = CompletedCollectionViewDataSource()
    
    // URGENT: probably shouldn't put this here because if there's no internet, it can't do this
    // should probably specify type here, then declare in viewDidLoad
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    let activeHaikusRef = ClientService.activeHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    let completedHaikusRef = ClientService.completedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    //up to here ^: should put somewhere else because what if there's no internet connection or internet connection gets lost between 
    
    @IBOutlet weak var noHaikusLabel: UILabel!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.CGColor
        segmentedControl.tintColor = kubazarDarkGreen
        
        fetchHaikusAndSetToDataSource()
        
        setInitialViewAndSelectedIndex()

        completedHaikusCollectionView.dataSource = completedCollectionViewDataSource
        
        completedHaikusCollectionView.delegate = self
        
        completedHaikusCollectionView.backgroundColor = UIColor.whiteColor()
        
        let completedNib = UINib.init(nibName: "CompletedHaikusCollectionViewCell", bundle: nil)
        
        completedHaikusCollectionView.registerNib(completedNib, forCellWithReuseIdentifier: "completedCell")
        
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
        
        
//           buttonAnimation(howToPlayStartButton)
//           imageAnimation(kubazarMascot)
    }
    
    func fetchHaikusAndSetToDataSource() {
       
        print("fetch Data gets called")
        
        ClientService.getCompletedHaikuImageURLStringsForCurrentUser { (arrayOfImageStrings) in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                
                let imageStringArray = arrayOfImageStrings
                
                self.completedCollectionViewDataSource.completedHaikus = []
                
                for imageString in imageStringArray {
                    let haikuImageRef = FIRStorage.storage().referenceForURL(imageString)
                    haikuImageRef.dataWithMaxSize(1 * 3000 * 3000, completion: { (data, error) in
                        if (error != nil) {
                            print(error)
                            print("something wrong with image download; maybe file too large")
                        } else {
                            
                            let haikuImage = UIImage(data: data!)
                            let completedHaiku = CompletedHaiku(imageString: imageString, image: haikuImage)
                            
                            print("/(completedHaiku) appended")
                            self.completedCollectionViewDataSource.completedHaikus.append(completedHaiku)
                            
                            self.completedHaikusCollectionView.reloadSections(NSIndexSet(index: 0))
                        }
                        
                    })
                }
                
            }
            
        }
    }
    
    @IBAction func startHaikuButton(sender: AnyObject) {
        startHaiku()
    }
    
    @IBAction func howToPlayStartButtonPressed(sender: AnyObject) {
        startHaiku()
    }
    
    
    func imageAnimation(imageView: UIImageView) {
        imageView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            imageView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func buttonAnimation(button: UIButton) {
        
        button.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func setInitialViewAndSelectedIndex() {
      
        setSegmentedViewsToHidden()
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        activeHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.noHaikusLabel.text = "You don't have any active haikus yet."
                self.noHaikusView.hidden = false
            } else {
                self.completedView.hidden = false
            }
        })

    
    }
   
    func setSegmentedViewsToHidden() {
        self.activeView.hidden = true
        self.completedView.hidden = true
        self.noHaikusView.hidden = true
    }
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setSegmentedViewsToHidden()
            
            activeHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.value is NSNull {
                    self.noHaikusLabel.text = "You don't have any active haikus yet."
                    self.noHaikusView.hidden = false
                } else {
                    self.completedView.hidden = false
                }
            })
            //if there are active haikus, then show active haikus. otherwise, show no haikusview.
//            buttonAnimation(self.howToPlayStartButton)
//            imageAnimation(self.kubazarMascot)

        case 1:
            
            setSegmentedViewsToHidden()
            
            completedHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.value is NSNull {
                    self.noHaikusLabel.text = "You don't have any completed haikus yet."
                    self.noHaikusView.hidden = false
                } else {
                    self.completedView.hidden = false
                }
                })

            

        default:
            
            break
        }
    
    }
    
    func startHaiku() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController?.selectedIndex = 1
    }
    
    
    

//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let haikuImage = completedCollectionViewDataSource.completedHaikus[indexPath.row]
//        
//        let haikuImageIndex = completedCollectionViewDataSource.completedHaikus.indexOf(haikuImage)!
//        
//        let haikuImageIndexPath = NSIndexPath(forRow: haikuImageIndex, inSection: 0)
//        
//        if let cell = self.completedHaikusCollectionView.cellForItemAtIndexPath(haikuImageIndexPath) as? CompletedHaikusCollectionViewCell {
//            cell.updateWithImage(haikuImage.image)
//            
//        }
//        
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let completedHaikuDetailVC = CompletedHaikuDetailViewController()
        presentViewController(completedHaikuDetailVC, animated: false) {
            let haikuImage = self.completedCollectionViewDataSource.completedHaikus[indexPath.row]
            completedHaikuDetailVC.completedHaikuDetailImageView.image = haikuImage.image
            completedHaikuDetailVC.animateButtons()
        }
    }
    
    
    
}
