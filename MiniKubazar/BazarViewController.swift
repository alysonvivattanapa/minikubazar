//
//  BazarViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseMessaging
import FirebaseInstanceID
import OneSignal

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
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    let activeHaikusRef = ClientService.activeHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    let newCompletedHaikusRef = ClientService.newCompletedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    @IBOutlet weak var noHaikusLabel: UILabel!
  
    @IBOutlet weak var activeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            
            if let oneSignalCurrentUserID = userId {
                
            ClientService.oneSignalIDsRef.child(self.currentUserUID).setValue(oneSignalCurrentUserID)
            // save to backend
                
            print("OneSignal UserId: \(oneSignalCurrentUserID)")

            }
        })
        
        
//        let token = FIRInstanceID.instanceID().token()!
//        print("TOKEN IS \(token)")
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.cgColor
        segmentedControl.tintColor = kubazarDarkGreen
        
        fetchCompletedHaikusAndSetToDataSource()
        
        fetchActiveHaikusAndSetToDataSource()
        
        setInitialViewAndSelectedIndex()

        completedHaikusCollectionView.dataSource = completedCollectionViewDataSource
        
        completedHaikusCollectionView.delegate = self
        
        activeCollectionView.dataSource = activeCollectionViewDataSource
        
        activeCollectionView.delegate = self
        
        activeCollectionView.backgroundColor = UIColor.white
        
        let activeNib = UINib.init(nibName: "ActiveCollectionViewCell", bundle: nil)
        
        activeCollectionView.register(activeNib, forCellWithReuseIdentifier: "activeCell")
        
        completedHaikusCollectionView.backgroundColor = UIColor.white
        
        let completedNib = UINib.init(nibName: "CompletedHaikusCollectionViewCell", bundle: nil)
        
        completedHaikusCollectionView.register(completedNib, forCellWithReuseIdentifier: "completedCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        print(completedCollectionViewDataSource.imageCache.object(forKey: <#T##AnyObject#>))
 // this should be taken care of by segmented control, but sometimes it takes a while for active haiku to post
//       activeHaikusRef.observeSingleEvent(of: .value, with: { (snapshot) in
//        
//        if self.segmentedControl.selectedSegmentIndex == 0 && snapshot.exists() && self.noHaikusLabel.text == "You don't have any active haikus yet." &&
//        self.noHaikusView.isHidden == false {
//            self.fetchActiveHaikusAndSetToDataSource()
//            self.completedView.isHidden = true
//            self.activeView.isHidden = false
//        }
//        
//        })
//        
        
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
        
    }
    
    func fetchActiveHaikusAndSetToDataSource() {
        
        print("fetch active haiku data gets called")
        
      ClientService.getActiveHaikuObjectsForCurrentUser { (arrayOfActiveHaikus) in
        OperationQueue.main.addOperation {
        self.activeCollectionViewDataSource.activeHaikus = arrayOfActiveHaikus
        self.activeCollectionView.reloadSections(IndexSet(integer: 0))
        }
        }
    }
    
    func fetchCompletedHaikusAndSetToDataSource() {
       
        print("fetch completed haiku Data gets called")
        
        ClientService.getCompletedHaikuObjectsForCurrentUser { (arrayOfCompletedHaikuObjects) in
          
            OperationQueue.main.addOperation {
                
                self.completedCollectionViewDataSource.completedHaikus = arrayOfCompletedHaikuObjects
                
                self.completedHaikusCollectionView.reloadSections(IndexSet(integer: 0))
                
            }
            
        }
    }
    
    @IBAction func startHaikuButton(_ sender: AnyObject) {
        startHaiku()
    }
    
    @IBAction func howToPlayStartButtonPressed(_ sender: AnyObject) {
        startHaiku()
    }
    
    
    func imageAnimation(_ imageView: UIImageView) {
        imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
            imageView.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func buttonAnimation(_ button: UIButton) {
        
        button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
            button.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func setInitialViewAndSelectedIndex() {
      
        setSegmentedViewsToHidden()
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        activeHaikusRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.noHaikusLabel.text = "You don't have any active haikus yet."
                self.noHaikusView.isHidden = false
            } else {
                self.completedView.isHidden = true
                self.activeView.isHidden = false
            }
        })

    
    }
   
    func setSegmentedViewsToHidden() {
        self.activeView.isHidden = true
        self.completedView.isHidden = true
        self.noHaikusView.isHidden = true
    }
    
    @IBAction func segmentedControlIndexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setSegmentedViewsToHidden()
            
            activeHaikusRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.value is NSNull {
                    self.noHaikusLabel.text = "You don't have any active haikus yet."
                    self.noHaikusView.isHidden = false
                } else {
                    self.completedView.isHidden = true
                    self.activeView.isHidden = false
                }
            })
            //if there are active haikus, then show active haikus. otherwise, show no haikusview.

        case 1:
            
            setSegmentedViewsToHidden()
            
            newCompletedHaikusRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.value is NSNull {
                    self.noHaikusLabel.text = "You don't have any completed haikus yet."
                    self.noHaikusView.isHidden = false
                } else {
                    self.completedView.isHidden = false
                }
                })

        default:
            
            break
        }
    
    }
    
    func startHaiku() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarController?.selectedIndex = 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        return CGSize(width: screenWidth, height: screenWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("did select \((indexPath as NSIndexPath).row)")
        
        if collectionView == self.activeCollectionView {
            
            let activeHaikuDetailVC = ActiveHaikuDetailViewController()
            
            let cell = self.activeCollectionView.cellForItem(at: indexPath) as! ActiveCollectionViewCell
            
            let activeHaiku = self.activeCollectionViewDataSource.activeHaikus[(indexPath as NSIndexPath).row]
            
            let currentUserUID = ClientService.getCurrentUserUID()
            
            if let firstPersonString = activeHaiku.firstPlayerUUID {
                activeHaikuDetailVC.firstPlayerUUID = firstPersonString
            }
            
            if let secondPersonString = activeHaiku.secondPlayerUUID {
                activeHaikuDetailVC.secondPlayerUUID = secondPersonString
            }
            
            if let thirdPersonString = activeHaiku.thirdPlayerUUID {
                activeHaikuDetailVC.thirdPlayerUUID = thirdPersonString
            }
            
            present(activeHaikuDetailVC, animated: true, completion: {
                
                let currentUserEmail = ClientService.getCurrentUserEmail()
                
                activeHaikuDetailVC.imageView.image = cell.imageView.image
                activeHaikuDetailVC.firstLineTextView.text = activeHaiku.firstLineString
                activeHaikuDetailVC.secondLineTextView.text = activeHaiku.secondLineString
                activeHaikuDetailVC.thirdLineTextView.text = activeHaiku.thirdLineString
                
                if let haikuUUID = activeHaiku.uniqueHaikuUUID {
                    activeHaikuDetailVC.uniqueHaikuUUID = haikuUUID
                }
                
                if let secondPlayer = activeHaikuDetailVC.secondPlayerUUID {
                    
                    if secondPlayer == currentUserUID && activeHaiku.secondLineString.contains("\(currentUserEmail) enters second line of haiku.") {
                        activeHaikuDetailVC.disableUserinteractionForAllTextViews()
                        activeHaikuDetailVC.secondLineTextView.backgroundColor = UIColor.yellow
                        activeHaikuDetailVC.secondLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                        activeHaikuDetailVC.thirdLineTextView.textColor = UIColor.lightGray
                        activeHaikuDetailVC.secondLineTextView.isUserInteractionEnabled = true
                        activeHaikuDetailVC.continueButton.isEnabled = true
                        activeHaikuDetailVC.continueButton.isHidden = false
                        activeHaikuDetailVC.waitForOtherPlayersLabel.text = "It's your turn! Press 'Continue' after you enter the second line of the haiku."
                    }
                }
                
                if let thirdPlayer = activeHaikuDetailVC.thirdPlayerUUID {
                    
                    if thirdPlayer == currentUserUID && activeHaiku.thirdLineString.contains("\(currentUserEmail) enters third line of haiku.") && !activeHaiku.secondLineString.contains("enters second line of haiku."){
                        activeHaikuDetailVC.disableUserinteractionForAllTextViews()
                        activeHaikuDetailVC.secondLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                        activeHaikuDetailVC.thirdLineTextView.backgroundColor = UIColor.yellow
                        activeHaikuDetailVC.thirdLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                        activeHaikuDetailVC.thirdLineTextView.isUserInteractionEnabled = true
                        activeHaikuDetailVC.continueButton.isEnabled = true
                        activeHaikuDetailVC.waitForOtherPlayersLabel.text = "It's your turn! Press 'Continue' after you enter the last line of the haiku."
                        activeHaikuDetailVC.continueButton.isHidden = false
                    }
                }
                
                
                if !activeHaiku.secondLineString.contains("enters second line of haiku.") {
                    activeHaikuDetailVC.secondLineTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
                }
                
                if cell.isItYourTurnLabel.text == "Waiting for a friend" {
                    activeHaikuDetailVC.disableUserinteractionForAllTextViews()
                    activeHaikuDetailVC.continueButton.isHidden = true
                }
            })
        }
        
        
        
                if collectionView == self.completedHaikusCollectionView {
                
                let completedHaikuDetailVC = CompletedHaikuDetailViewController()
                
                let cell = self.completedHaikusCollectionView.cellForItem(at: indexPath) as! CompletedHaikusCollectionViewCell
                
                self.present(completedHaikuDetailVC, animated: false) {
                let haikuObject = self.completedCollectionViewDataSource.completedHaikus[(indexPath as NSIndexPath).row]
                completedHaikuDetailVC.completedHaikuDetailImageView.image = cell.completedHaikuImageView.image
                completedHaikuDetailVC.firstLineLabel.text = haikuObject.firstLineString
                completedHaikuDetailVC.secondLineLabel.text = haikuObject.secondLineString
                completedHaikuDetailVC.thirdLineLabel.text = haikuObject.thirdLineString
                completedHaikuDetailVC.uniqueHaikuUUID = haikuObject.uniqueHaikuUUID
                completedHaikuDetailVC.animateButtons()
                }
            }
        }
    
   
        
}
