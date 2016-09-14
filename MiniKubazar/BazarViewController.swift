//
//  BazarViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import FirebaseStorage

class BazarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var howToPlayView: UIView!
   
    @IBOutlet weak var activeStartView: UIView!
    
    @IBOutlet weak var completedView: UIView!
    
    @IBOutlet weak var completedHaikusCollectionView: UICollectionView!
    
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var startHaikuButton: UIButton!
    
    @IBOutlet weak var howToPlayStartButton: UIButton!
    
    
    var arrayOfImageURLStrings = [String]()
    
    var arrayOfImages = [UIImage]()
    
    // URGENT: probably shouldn't put this here because if there's no internet, it can't do this
    // should probably specify type here, then declare in viewDidLoad
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    let currentActiveHaikusRef = ClientService.activeHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    let completedHaikusRef = ClientService.completedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    //up to here ^: should put somewhere else because what if there's no internet connection or internet connection gets lost between 
    
    @IBOutlet weak var startHaikuLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialViewAndSelectedIndex()
        
        setInitialDataForCollectionView()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
//        layout.itemSize = CGSize(width: 250, height: 250)
        
        completedHaikusCollectionView.dataSource = self
        
        completedHaikusCollectionView.delegate = self
        
        completedHaikusCollectionView.backgroundColor = UIColor.whiteColor()
        
            let completedNib = UINib.init(nibName: "CompletedHaikusCollectionViewCell", bundle: nil)
        
        
            completedHaikusCollectionView.registerNib(completedNib, forCellWithReuseIdentifier: "completedCell")
        
    }
    
    func setInitialDataForCollectionView() {
        completedHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.value is NSNull {
                
                print("You have no completed haikus. Start a haiku!")
                
                self.activeStartView.hidden = false
                self.startHaikuLabel.text = "You have no completed haikus."
                
            } else {
                print("this snapshot exists")
                
                ClientService.getCompletedHaikuImageURLStringsForCurrentUser({ (arrayOfImages) in
                    self.arrayOfImageURLStrings = arrayOfImages
                    
                    for imageString in self.arrayOfImageURLStrings {
                        
                        let completedHaikuImageHttpsRef = FIRStorage.storage().referenceForURL(imageString)
                        
                        completedHaikuImageHttpsRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                            if (error != nil) {
                                print("image file too large to download?")
                            } else {
                                let completedHaikuImage: UIImage! = UIImage(data: data!)
                                self.arrayOfImages.append(completedHaikuImage)
                                if self.arrayOfImages.count == self.arrayOfImageURLStrings.count {
                                    self.completedHaikusCollectionView.reloadData()
                                }
                            }
                        })
                        
                    }
                    
                })
           
        }
        })

    }
    
    
    @IBAction func startHaikuButton(sender: AnyObject) {
        startHaiku()
    }
    

    
//    override func viewWillAppear(animated: Bool) {
    
    
//    
//    completedHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//    
//    if snapshot.value is NSNull {
//    
//    print("You have no completed haikus. Start a haiku!")
//    
//    self.activeStartView.hidden = false
//    self.startHaikuLabel.text = "You have no completed haikus."
//    
//    } else {
//    self.completedView.hidden = false
//    
//    if self.arrayOfImages.count < 1 {
//    
//    self.setInitialDataForCollectionView()
//    
//    } else {
//    
//    self.checkForNewHaikus()
//    
//    
//    }
//    }
//    })
    
    
    
//
//        //check for additional images
//
//
//        ClientService.getCompletedHaikuImageURLStringsForCurrentUser { (arrayOfStrings) in
//            for imageString in arrayOfStrings {
//                if self.arrayOfImageURLStrings.contains(imageString) {
//                //do nothing
//
//                } else {
//                    //get image and add to collection view
//                    let completedHaikuImageHttpsRef = FIRStorage.storage().referenceForURL(imageString)
//                    
//                    completedHaikuImageHttpsRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
//                        if (error != nil) {
//                            print("image file too large to download?")
//                        } else {
//                            
//                            
//                            if self.arrayOfImages.count < 1 {
//                                // do nothing
//                            } else {
//                                
//                                let completedHaikuImage: UIImage! = UIImage(data: data!)
//                                //                                self.arrayOfImages.append(completedHaikuImage)
//                                
//                                
//                                let newIndexPath = NSIndexPath(forItem: self.arrayOfImages.indexOf(completedHaikuImage)!, inSection: 0)
//                                
//                                self.arrayOfImages.append(completedHaikuImage)
//                            self.completedHaikusCollectionView.insertItemsAtIndexPaths([newIndexPath])
//                            }
//                        }
//                    })
//                    
//                }
//            }
//        }
//        
//
//        
//        
//        //include what happens when Reachabiity says there's no internet
//        
//      
//    }
    
    
    func checkForNewHaikus() {
        ClientService.getCompletedHaikuImageURLStringsForCurrentUser { (arrayOfStrings) in
            
            for imageString in arrayOfStrings {
                if self.arrayOfImageURLStrings.contains(imageString) {
                    
                    print("collection view should already contain data from this image string \(imageString)")
                    
                } else {
                    
                    let completedHaikuImageHttpsRef = FIRStorage.storage().referenceForURL(imageString)
                    
                    completedHaikuImageHttpsRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                        
                        if (error != nil) {
                            print("image file for new cell is too big?")
                            
                        } else {
                            
                            if self.arrayOfImageURLStrings.count > 1 {
                                let completedHaikuImage: UIImage! = UIImage(data: data!)
                                self.arrayOfImages.append(completedHaikuImage)
                                let newIndexPath = NSIndexPath(forItem: self.arrayOfImages.indexOf(completedHaikuImage)!, inSection: 0)
                                self.completedHaikusCollectionView.insertItemsAtIndexPaths([newIndexPath])
                            }
                        }
                    })
                }
                }}
            }
            
            
            //            for imageString in arrayOfStrings {
            //                if self.arrayOfImageURLStrings.contains(imageString) {
            //                //do nothing
            //
            //                } else {
            //                    //get image and add to collection view
            //                    let completedHaikuImageHttpsRef = FIRStorage.storage().referenceForURL(imageString)
            //
            //                    completedHaikuImageHttpsRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
            //                        if (error != nil) {
            //                            print("image file too large to download?")
            //                        } else {
            //
            //
            //                            if self.arrayOfImages.count < 1 {
            //                                // do nothing
            //                            } else {
            //
            //                                let completedHaikuImage: UIImage! = UIImage(data: data!)
            //                                //                                self.arrayOfImages.append(completedHaikuImage)
            //
            //
            //                                let newIndexPath = NSIndexPath(forItem: self.arrayOfImages.indexOf(completedHaikuImage)!, inSection: 0)
            //
            //                                self.arrayOfImages.append(completedHaikuImage)
            //                            self.completedHaikusCollectionView.insertItemsAtIndexPaths([newIndexPath])
            //                            }
            //                        }
            //                    })
            //                    
            //                }
            //            }
            //        }
            //        
            //
            //        
            //        
            //        //include what happens when Reachabiity says there's no internet
            //        
    
    func buttonAnimation(button: UIButton) {
        
        button.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func setInitialViewAndSelectedIndex() {
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        segmentedControl.layer.borderColor = kubazarDarkGreen.CGColor
        segmentedControl.tintColor = kubazarDarkGreen
        
        setSegmentedViewsToHidden()
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        self.howToPlayView.hidden = false
        
        //button animation isn't working for some reason???
//        buttonAnimation(howToPlayStartButton)
//        
//        self.howToPlayStartButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
//        
//        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
//            self.howToPlayStartButton.transform = CGAffineTransformIdentity
//            }, completion: nil)
    }
   
    func setSegmentedViewsToHidden() {
        self.howToPlayView.hidden = true
        self.completedView.hidden = true
        self.activeStartView.hidden = true
    }
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // show howToPlayView
            setSegmentedViewsToHidden()
            self.howToPlayView.hidden = false

        case 1:
            
            setSegmentedViewsToHidden()
            if self.arrayOfImages.count > 0 {
                self.completedView.hidden = false
            } else {
                self.activeStartView.hidden = false
            }
            
          
            
//            if self.arrayOfImages.count < 1 {
//            setInitialDataForCollectionView()
//            } else {
            //    checkForNewHaikus()
//            }
            
        
//            self.completedView.hidden = false
//            self.howToPlayView.hidden = true
//            self.activeStartView.hidden = true

        default:
            
            break
        }
    
    }
    
    func startHaiku() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.tabBarController?.selectedIndex = 1
    }
 
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = completedHaikusCollectionView.dequeueReusableCellWithReuseIdentifier("completedCell", forIndexPath: indexPath) as! CompletedHaikusCollectionViewCell
        
        let haikuImage = arrayOfImages[indexPath.row]
        cell.completedHaikuImageView.image = nil
        cell.completedHaikuImageView.image = haikuImage
       
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let completedDetailVC = CompletedHaikuDetailViewController()
        presentViewController(completedDetailVC, animated: true) { 
            completedDetailVC.completedHaikuDetailImageView.image = self.arrayOfImages[indexPath.row]
        }
       
    }
    
    
}
