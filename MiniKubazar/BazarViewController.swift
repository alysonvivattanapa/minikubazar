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
    
    let newCompletedHaikusRef = ClientService.newCompletedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    //up to here ^: should put somewhere else because what if there's no internet connection or internet connection gets lost between 
    
    @IBOutlet weak var noHaikusLabel: UILabel!
  
    @IBOutlet weak var activeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
//           buttonAnimation(howToPlayStartButton)
//           imageAnimation(kubazarMascot)
    }
    
    func fetchActiveHaikusAndSetToDataSource() {
        
        print("fetch active haiku data gets called")
        
      ClientService.getActiveHaikuObjectsForCurrentUser { (arrayOfActiveHaikus) in
        OperationQueue.main.addOperation {
        self.activeCollectionViewDataSource.activeHaikus = arrayOfActiveHaikus
        self.activeCollectionView.reloadSections(IndexSet(integer: 0))
        }
        }
        //get activeHaikuObjects
        // do something to get image from imageURL in collection view cellForIndexPath
        // append 
    }
    
    func fetchCompletedHaikusAndSetToDataSource() {
       
        print("fetch completed haiku Data gets called")
        
        ClientService.getCompletedHaikuObjectsForCurrentUser { (arrayOfCompletedHaikuObjects) in
          
            OperationQueue.main.addOperation {
                
                self.completedCollectionViewDataSource.completedHaikus = arrayOfCompletedHaikuObjects
                
                self.completedHaikusCollectionView.reloadSections(IndexSet(integer: 0))
                
//                for 
//                
//                for imageString in imageStringArray {
//                    let haikuImageRef = FIRStorage.storage().referenceForURL(imageString)
//                    haikuImageRef.dataWithMaxSize(1 * 3000 * 3000, completion: { (data, error) in
//                        if (error != nil) {
//                            print(error)
//                            print("something wrong with image download; maybe file too large")
//                        } else {
//                            
//                            let haikuImage = UIImage(data: data!)
//                            let completedHaiku = CompletedHaiku(imageString: imageString, image: haikuImage)
//                            
//                            print("/(completedHaiku) appended")
//                            self.completedCollectionViewDataSource.completedHaikus.append(completedHaiku)
//                            
//                            self.completedHaikusCollectionView.reloadSections(NSIndexSet(index: 0))
                      //  }
                        
                 //   })
              //  }
                
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
//            buttonAnimation(self.howToPlayStartButton)
//            imageAnimation(self.kubazarMascot)

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
            
        
            
                        present(activeHaikuDetailVC, animated: true, completion: {
                            
                            activeHaikuDetailVC.imageView.image = cell.imageView.image
                            activeHaikuDetailVC.firstLineTextView.text = activeHaiku.firstLineString
                            
                            print(activeHaiku)
                            activeHaikuDetailVC.secondLineTextView.text = activeHaiku.secondLineString
                            activeHaikuDetailVC.thirdLineTextView.text = activeHaiku.thirdLineString
                            
                            if let haikuUUID = activeHaiku.uniqueHaikuUUID {
                                activeHaikuDetailVC.uniqueHaikuUUID = haikuUUID
                            }
                            
                            if let secondPlayer = activeHaikuDetailVC.secondPlayerUUID {
                            
                                            if secondPlayer == currentUserUID && activeHaiku.secondLineString.contains("enters second line of haiku.") {
                                                activeHaikuDetailVC.secondLineTextView.backgroundColor = UIColor.yellow
                                                activeHaikuDetailVC.secondLineTextView.textColor = UIColor.cyan
                                                activeHaikuDetailVC.secondLineTextView.isUserInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.isEnabled = true
                                                activeHaikuDetailVC.continueButton.isHidden = false
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.isHidden = true
                              }
                            
                                            if secondPlayer == currentUserUID && activeHaiku.secondLineString.contains("Waiting on second player") {
                                                activeHaikuDetailVC.secondLineTextView.backgroundColor = UIColor.yellow
                                                activeHaikuDetailVC.secondLineTextView.textColor = UIColor.cyan
                                                activeHaikuDetailVC.secondLineTextView.isUserInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.isEnabled = true
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.isHidden = true
                                                activeHaikuDetailVC.continueButton.isHidden = false
                                            }
                            }
                            
                            if let thirdPlayer = activeHaikuDetailVC.thirdPlayerUUID {
                                
                                                if thirdPlayer == currentUserUID && activeHaiku.thirdLineString.contains("enters second line, you can write third line") && !activeHaiku.secondLineString.contains("Waiting on second player"){
                                
                                                   activeHaikuDetailVC.thirdLineTextView.backgroundColor = UIColor.yellow
                                                   activeHaikuDetailVC.thirdLineTextView.textColor = UIColor.cyan
                                                  activeHaikuDetailVC.thirdLineTextView.isUserInteractionEnabled = true
                                                    activeHaikuDetailVC.continueButton.isEnabled = true
                                                    activeHaikuDetailVC.waitForOtherPlayersLabel.isHidden = true
                                                activeHaikuDetailVC.continueButton.isHidden = false
                                                    }
                                
                                            if thirdPlayer == currentUserUID && activeHaiku.thirdLineString.contains("Write here after second player's turn") && !activeHaiku.secondLineString.contains("Waiting on second player"){
                            
                                                activeHaikuDetailVC.thirdLineTextView.backgroundColor = UIColor.yellow
                                                activeHaikuDetailVC.thirdLineTextView.textColor = UIColor.cyan
                                                activeHaikuDetailVC.thirdLineTextView.isUserInteractionEnabled = true
                                                activeHaikuDetailVC.continueButton.isEnabled = true
                                                activeHaikuDetailVC.waitForOtherPlayersLabel.isHidden = true
                                                activeHaikuDetailVC.continueButton.isHidden = false
                                                
                                } }


            })
        }
      
        
        if collectionView == self.completedHaikusCollectionView {
        
        let completedHaikuDetailVC = CompletedHaikuDetailViewController()
            
            let cell = self.completedHaikusCollectionView.cellForItem(at: indexPath) as! CompletedHaikusCollectionViewCell

        present(completedHaikuDetailVC, animated: false) {
            let haikuObject = self.completedCollectionViewDataSource.completedHaikus[(indexPath as NSIndexPath).row]
            completedHaikuDetailVC.completedHaikuDetailImageView.image = cell.completedHaikuImageView.image
            completedHaikuDetailVC.firstLineLabel.text = haikuObject.firstLineString
            completedHaikuDetailVC.secondLineLabel.text = haikuObject.secondLineString
            completedHaikuDetailVC.thirdLineLabel.text = haikuObject.thirdLineString
            completedHaikuDetailVC.animateButtons()
        }
        }
    }
//
    
    
}
