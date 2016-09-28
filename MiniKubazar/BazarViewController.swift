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
    
    @IBOutlet weak var startHaikuButton: UIButton!
    
    @IBOutlet weak var kubazarMascot: UIImageView!
    
    
    let completedCollectionViewDataSource = CompletedCollectionViewDataSource()
    
    let activeCollectionViewDataSource = ActiveCollectionViewDataSource()
    
    // URGENT: probably shouldn't put this here because if there's no internet, it can't do this
    // should probably specify type here, then declare in viewDidLoad
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    let activeHaikusRef = ClientService.activeHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    let completedHaikusRef = ClientService.completedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    //up to here ^: should put somewhere else because what if there's no internet connection or internet connection gets lost between 
    
    @IBOutlet weak var noHaikusLabel: UILabel!
  
    @IBOutlet weak var activeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.CGColor
        segmentedControl.tintColor = kubazarDarkGreen
        
        fetchCompletedHaikusAndSetToDataSource()
        
        fetchActiveHaikusAndSetToDataSource()
        
        setInitialViewAndSelectedIndex()

        completedHaikusCollectionView.dataSource = completedCollectionViewDataSource
        
        completedHaikusCollectionView.delegate = self
        
        activeCollectionView.dataSource = activeCollectionViewDataSource
        
        activeCollectionView.delegate = self
        
        activeCollectionView.backgroundColor = UIColor.whiteColor()
        
        let activeNib = UINib.init(nibName: "ActiveCollectionViewCell", bundle: nil)
        
        activeCollectionView.registerNib(activeNib, forCellWithReuseIdentifier: "activeCell")
        
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
    
    func fetchActiveHaikusAndSetToDataSource() {
        
        print("fetch active haiku data gets called")
        
      ClientService.getActiveHaikuObjectsForCurrentUser { (arrayOfActiveHaikus) in
        NSOperationQueue.mainQueue().addOperationWithBlock {
        self.activeCollectionViewDataSource.activeHaikus = arrayOfActiveHaikus
        self.activeCollectionView.reloadSections(NSIndexSet(index: 0))
        }
        }
        //get activeHaikuObjects
        // do something to get image from imageURL in collection view cellForIndexPath
        // append 
    }
    
    func fetchCompletedHaikusAndSetToDataSource() {
       
        print("fetch completed haiku Data gets called")
        
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
                self.completedView.hidden = true
                self.activeView.hidden = false
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
                    self.completedView.hidden = true
                    self.activeView.hidden = false
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
        
        print("did select \(indexPath.row)")
        
        if collectionView == self.activeCollectionView {
        
         let activeHaikuDetailVC = ActiveHaikuDetailViewController()
        
        
            
        let cell = self.activeCollectionView.cellForItemAtIndexPath(indexPath) as! ActiveCollectionViewCell
            
            let activeHaiku = self.activeCollectionViewDataSource.activeHaikus[indexPath.row]
            
              let currentUserUID = ClientService.getCurrentUserUID()
            
            if let firstPersonString = activeHaiku.firstPlayerUUID {
                print("FIRST PERSON STRING FROM BAZARVC \(firstPersonString)")
                activeHaikuDetailVC.firstPlayerUUID = firstPersonString
                
            }
            
            if let secondPersonString = activeHaiku.secondPlayerUUID {
                print("SECOND PERSON STRING FROM BAZARVC \(secondPersonString)")
                activeHaikuDetailVC.secondPlayerUUID = secondPersonString
            }
            
            if let thirdPersonString = activeHaiku.thirdPlayerUUID {
                print("THIRD PERSON STRING FROM BAZARVC \(thirdPersonString)")
                activeHaikuDetailVC.thirdPlayerUUID = thirdPersonString
                
            }
            
        
            
                        presentViewController(activeHaikuDetailVC, animated: true, completion: {
                            
                            activeHaikuDetailVC.imageView.image = cell.imageView.image
                            activeHaikuDetailVC.firstLineTextView.text = activeHaiku.firstLineString
                            
                            print(activeHaiku)
                            activeHaikuDetailVC.secondLineTextView.text = activeHaiku.secondLineString
                            activeHaikuDetailVC.thirdLineTextView.text = activeHaiku.thirdLineString
                            
                            if let haikuUUID = activeHaiku.uniqueHaikuUUID {
                                activeHaikuDetailVC.uniqueHaikuUUID = haikuUUID
                            }
                            
                            if let secondPlayer = activeHaikuDetailVC.secondPlayerUUID {
                            
                                            if secondPlayer == currentUserUID && activeHaiku.secondLineString.containsString("enters second line of haiku.") {
                                                activeHaikuDetailVC.secondLineTextView.backgroundColor = UIColor.yellowColor()
                                                activeHaikuDetailVC.secondLineTextView.textColor = UIColor.cyanColor()
                                                activeHaikuDetailVC.secondLineTextView.userInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.enabled = true
                                                activeHaikuDetailVC.continueButton.hidden = false
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.hidden = true
                              }
                            
                                            if secondPlayer == currentUserUID && activeHaiku.secondLineString.containsString("Waiting on second player") {
                                                activeHaikuDetailVC.secondLineTextView.backgroundColor = UIColor.yellowColor()
                                                activeHaikuDetailVC.secondLineTextView.textColor = UIColor.cyanColor()
                                                activeHaikuDetailVC.secondLineTextView.userInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.enabled = true
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.hidden = true
                                                activeHaikuDetailVC.continueButton.hidden = false
                                            }
                            }
                            
                            if let thirdPlayer = activeHaikuDetailVC.thirdPlayerUUID {
                                
                                                if thirdPlayer == currentUserUID && activeHaiku.thirdLineString.containsString("enters second line, you can write third line") && !activeHaiku.secondLineString.containsString("Waiting on second player"){
                                
                                                   activeHaikuDetailVC.thirdLineTextView.backgroundColor = UIColor.yellowColor()
                                                   activeHaikuDetailVC.thirdLineTextView.textColor = UIColor.cyanColor()
                                                  activeHaikuDetailVC.thirdLineTextView.userInteractionEnabled = true
                                                    activeHaikuDetailVC.continueButton.enabled = true
                                                    activeHaikuDetailVC.waitForOtherPlayersLabel.hidden = true
                                                activeHaikuDetailVC.continueButton.hidden = false
                                                    }
                                
                                            if thirdPlayer == currentUserUID && activeHaiku.thirdLineString.containsString("Write here after second player's turn") && !activeHaiku.secondLineString.containsString("Waiting on second player"){
                            
                                                activeHaikuDetailVC.thirdLineTextView.backgroundColor = UIColor.yellowColor()
                                                activeHaikuDetailVC.thirdLineTextView.textColor = UIColor.cyanColor()
                                                activeHaikuDetailVC.thirdLineTextView.userInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.enabled = true
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.hidden = true
                                                activeHaikuDetailVC.continueButton.hidden = false
                                                
                                } }


            })
        }
      
        
        if collectionView == self.completedHaikusCollectionView {
        
        let completedHaikuDetailVC = CompletedHaikuDetailViewController()
        presentViewController(completedHaikuDetailVC, animated: false) {
            let haikuImage = self.completedCollectionViewDataSource.completedHaikus[indexPath.row]
            completedHaikuDetailVC.completedHaikuDetailImageView.image = haikuImage.image
            completedHaikuDetailVC.animateButtons()
        }
        }
    }
//
    
    
}
