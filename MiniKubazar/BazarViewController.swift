//
//  BazarViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class BazarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var activeStartView: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var activeView: UIView!
    
    @IBOutlet weak var completedView: UIView!
    
    @IBOutlet weak var activeTableView: UITableView!
    
    @IBOutlet weak var completedTableView: UITableView!
    
    @IBOutlet weak var startHaikuButton: UIButton!
    
    
    struct PreviewDetail {
        let title: String
        let preferredHeight: Double
    }
    
    let sampleData = [
        PreviewDetail(title: "Small", preferredHeight: 160.0),
        PreviewDetail(title: "Medium", preferredHeight: 320.0),
        PreviewDetail(title: "Large", preferredHeight: 0.0) // 0.0 to get the default height.
    ]
    
    let sampleData1 = [
        PreviewDetail(title: "One", preferredHeight: 160.0),
        PreviewDetail(title: "Two", preferredHeight: 320.0),
        PreviewDetail(title: "Three", preferredHeight: 0.0), // 0.0 to get the default height.
        PreviewDetail(title: "More", preferredHeight: 0.0) // 0.0 to get the default height.
    ]
    
    // URGENT: probably shouldn't put this here because if there's no internet, it can't do this
    
    let currentUserUID = ClientService.getCurrentUserUID()
    
    let currentActiveHaikusRef = ClientService.activeHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    let completedHaikusRef = ClientService.completedHaikusRef.child("\(ClientService.getCurrentUserUID())")
    
    //up to here ^: should put somewhere else because what if there's no internet connection or internet connection gets lost between 
    
    @IBOutlet weak var startHaikuLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        activeTableView.dataSource = self
        
        activeTableView.delegate = self
        
        let activeNib = UINib.init(nibName: "ActiveHaikusTableViewCell", bundle: nil)
        activeTableView.registerNib(activeNib, forCellReuseIdentifier: "activeCell")
        
        completedTableView.dataSource = self
        
        completedTableView.delegate = self
        
        let completedNib = UINib.init(nibName: "CompletedHaikusTableViewCell", bundle: nil)
        completedTableView.registerNib(completedNib, forCellReuseIdentifier: "completedCell")
    }
    
    
    @IBAction func startHaikuButton(sender: AnyObject) {
        startHaiku()
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
       
        
        let kubazarDarkGreen = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)

        segmentedControl.layer.borderColor = kubazarDarkGreen.CGColor
        segmentedControl.tintColor = kubazarDarkGreen
            
        
        setAllViewsToZero()
        
        //include what happens when Reachabiity says there's no internet
        
         self.segmentedControl.selectedSegmentIndex = 0
         currentActiveHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.value is NSNull {
                
                print("You have no active haikus. Start a haiku!")
                
                self.startHaikuButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
                
                self.activeView.alpha = 0
                self.completedView.alpha = 0
                self.activeStartView.alpha = 1
                self.startHaikuLabel.text = "You have no active haikus."
                
                UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
                    self.startHaikuButton.transform = CGAffineTransformIdentity
                    }, completion: nil)

                
                
            } else {
                print("this snapshot exists")
                
                self.activeView.alpha = 1
                self.completedView.alpha = 0
                self.activeStartView.alpha = 0
            }
        })
    }
   
    func setAllViewsToZero() {
        self.activeView.alpha = 0
        self.completedView.alpha = 0
        self.activeStartView.alpha = 0
    }
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            //show active haikus
            
            currentActiveHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.value is NSNull {
                    
                    print("You have no active haikus. Start a haiku!")
                
                    self.activeView.alpha = 0
                    self.completedView.alpha = 0
                    self.activeStartView.alpha = 1
                    self.startHaikuLabel.text = "You have no active haikus."
                    
                    
                } else {
                    print("this snapshot exists")

                    self.activeView.alpha = 1
                    self.completedView.alpha = 0
                    self.activeStartView.alpha = 0
                }
            })

        case 1:
           
            //show completed haikus
            
            completedHaikusRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.value is NSNull {
                    
                    print("You have no completed haikus. Start a haiku!")
                    
                    self.activeView.alpha = 0
                    self.completedView.alpha = 0
                    self.activeStartView.alpha = 1
                    self.startHaikuLabel.text = "You have no completed haikus."
                    
                } else {
                    print("this snapshot exists")

                    self.activeView.alpha = 0
                    self.completedView.alpha = 1
                    self.activeStartView.alpha = 0
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.activeTableView {
            count = sampleData.count
        }
        
        if tableView == self.completedTableView {
            count = sampleData1.count
        }
        
        return count!
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if tableView == self.activeTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("activeCell", forIndexPath: indexPath) as! ActiveHaikusTableViewCell
            let previewDetail = sampleData[indexPath.row]
            cell!.textLabel?.text = previewDetail.title
        }
    
        if tableView == self.completedTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("completedCell", forIndexPath: indexPath) as! CompletedHaikusTableViewCell
            let previewDetail = sampleData1[indexPath.row]
            cell!.textLabel?.text = previewDetail.title
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select: \(indexPath.row)")
    }
    
    
    
}
