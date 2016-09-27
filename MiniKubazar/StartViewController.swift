//
//  StartViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate {

    @IBOutlet weak var firstKubazarMascot: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var playWithOneFriendButton: UIButton!
    
    @IBOutlet weak var playWithTwoFriendsButton: UIButton!
    
    
    @IBOutlet weak var createNewHaikuView: UIView!
    
    @IBOutlet weak var createNewHaikuLabel: UILabel!
    
    @IBOutlet weak var choosePictureView: UIView!
    
    @IBOutlet weak var enterHaikuView: UIView!
    
    @IBOutlet weak var firstLineHaikuTextView: UITextView!
    
    @IBOutlet weak var secondLineHaikuTextView: UITextView!
    
    @IBOutlet weak var thirdLineHaikuTextView: UITextView!
    
    
    @IBOutlet weak var congratsView: UIView!
    // congratsView should take you to active bazar table view
    // table view selection goes to detail view that includes share button?
    
    
    @IBOutlet weak var haikuImageView: UIImageView!
    
    var recentlyFinishedHaikuUID: String!
    
    var animator: UIDynamicAnimator!
    
    var gravity: UIGravityBehavior!
    
    var collision: UICollisionBehavior!
    
    @IBOutlet weak var finishedImageView: UIImageView!
    
    @IBOutlet weak var firstLineHaikuLabel: UILabel!
    
    @IBOutlet weak var secondLineHaikuLabel: UILabel!
    
    @IBOutlet weak var thirdLineHaikuLabel: UILabel!
    
    
    @IBOutlet weak var shareableHaikuView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var cameraRollButton: UIButton!
    
    @IBOutlet weak var inspireMeButton: UIButton!
    
    @IBOutlet weak var chooseFriendsTableView: UITableView!
    
    let chooseFriendsTableViewDataSource = FriendsTableViewDataSource()
    
    
    @IBOutlet weak var chooseFriendsView: UIView!
    
    
    @IBOutlet weak var chooseFriendsContineButton: UIButton!
    
    
    @IBOutlet weak var chooseFriendsLabel: UILabel!
    
    var oneFriendOptionChosen: Bool!
    
    var twoFriendsOptionChosen: Bool!
    
    var arrayOfChosenFriends = [String]()
    
    
    @IBOutlet weak var enterHaikuFinishButton: UIButton!
   
    
    @IBOutlet weak var enterHaikuContinueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLineHaikuTextView.delegate = self
        secondLineHaikuTextView.delegate = self
        thirdLineHaikuTextView.delegate = self
        
        chooseFriendsTableView.dataSource = chooseFriendsTableViewDataSource
        chooseFriendsTableView.delegate = self
       
        
        fetchFriendsAndSetToDataSource()
        
        let friendsNib = UINib.init(nibName: "FriendsTableViewCell", bundle: nil)
        chooseFriendsTableView.registerNib(friendsNib, forCellReuseIdentifier: "friendsCell")
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    stepOneCreateNewHaiku()
    
        
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
        
        
        firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables"
        secondLineHaikuTextView.text = "Enter second line of haiku: 7 syllables"
        thirdLineHaikuTextView.text = "Enter third line of haiku: 5 syllables"
        firstLineHaikuTextView.textColor = UIColor.lightGrayColor()
        secondLineHaikuTextView.textColor = UIColor.lightGrayColor()
        thirdLineHaikuTextView.textColor = UIColor.lightGrayColor()
        
        if createNewHaikuView.hidden == false {
            startAnimation()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
            textView.backgroundColor = UIColor(red: 90.0/255, green: 191.0/255, blue: 188.0/255, alpha: 1)
            textView.layer.cornerRadius = 5
            textView.clipsToBounds = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stepOneCreateNewHaiku() {
        
        setAllSubviewsToHidden()
        createNewHaikuView.hidden = false
        startAnimation()

    }
    
    func startAnimation() {
        startButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        playWithOneFriendButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        playWithTwoFriendsButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        firstKubazarMascot.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        createNewHaikuLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)

        
//        animator = UIDynamicAnimator(referenceView: self.createNewHaikuView)
//        gravity = UIGravityBehavior(items: [firstKubazarMascot])
//        animator.addBehavior(gravity)
//        
//        collision = UICollisionBehavior(items: [firstKubazarMascot])
//        collision.addBoundaryWithIdentifier("createNewHaikuLabel", forPath: UIBezierPath(rect: createNewHaikuLabel.frame))
//        
//        collision.translatesReferenceBoundsIntoBoundary = true
//        animator.addBehavior(collision)
//        
//        let itemBehavior = UIDynamicItemBehavior(items: [firstKubazarMascot])
//        itemBehavior.elasticity = 0.7
//        animator.addBehavior(itemBehavior)
        
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            self.startButton.transform = CGAffineTransformIdentity
            self.playWithOneFriendButton.transform = CGAffineTransformIdentity
            self.playWithTwoFriendsButton.transform = CGAffineTransformIdentity
            self.firstKubazarMascot.transform = CGAffineTransformIdentity
            self.createNewHaikuLabel.transform = CGAffineTransformIdentity
            }, completion: nil)
        
    }
    
    func imageViewAnimation(imageView: UIImageView){
        imageView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            imageView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func buttonAnimation(button: UIButton){
        button.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func stepTwoChoosePicture() {
        setAllSubviewsToHidden()
        choosePictureView.hidden = false
        buttonAnimation(cameraButton)
        buttonAnimation(cameraRollButton)
        buttonAnimation(inspireMeButton)
        enterHaikuContinueButton.hidden = true
        enterHaikuFinishButton.hidden = false
    }
    
    @IBAction func choosePictureBackButtonPressed(sender: AnyObject) {
        stepOneCreateNewHaiku()
       
    }
    
    
    func stepThreeEnterHaiku() {
        setAllSubviewsToHidden()
        enterHaikuView.hidden = false
        imageViewAnimation(haikuImageView)
    }
    
    func stepFourCongrats() {
//        setAllSubviewsToHidden()
        setShareableHaikuImage()
//        congratsView.hidden = false
    }
    
    func setShareableHaikuImage() {
        firstLineHaikuLabel.text = firstLineHaikuTextView.text
        secondLineHaikuLabel.text = secondLineHaikuTextView.text
        thirdLineHaikuLabel.text = thirdLineHaikuTextView.text
        
        finishedImageView.image = haikuImageView.image
        
    }
    
        
    @IBAction func startButtonPressed(sender: AnyObject) {
        stepTwoChoosePicture()
    }
    
    
    @IBAction func thirdBackButtonPressed(sender: AnyObject) {
//        haikuFirstLine.text? = ""
//        haikuSecondLine.text? = ""
//        haikuThirdLine.text? = ""
       stepTwoChoosePicture()
       self.view.endEditing(true)
        firstLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        secondLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        thirdLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables"
        secondLineHaikuTextView.text = "Enter second line of haiku: 7 syllables"
        thirdLineHaikuTextView.text = "Enter third line of haiku: 5 syllables"
        firstLineHaikuTextView.textColor = UIColor.lightGrayColor()
        secondLineHaikuTextView.textColor = UIColor.lightGrayColor()
        thirdLineHaikuTextView.textColor = UIColor.lightGrayColor()
        
        enterHaikuContinueButton.hidden = true
        enterHaikuFinishButton.hidden = false
    
    }
    
    
    func setAllSubviewsToHidden() {
        createNewHaikuView.hidden = true
        choosePictureView.hidden = true
        enterHaikuView.hidden = true
        congratsView.hidden = true
        chooseFriendsView.hidden = true
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cameraRollButtonPressed(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        haikuImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
        stepThreeEnterHaiku()
    }
    
    
    
    @IBAction func inspireMeButtonPressed(sender: AnyObject) {
        
        let random = arc4random_uniform(8)
        
        switch random {
        case 0:
           
             haikuImageView.image = UIImage(named: "inspireMe1")
            
        case 1:
            
            haikuImageView.image = UIImage(named: "inspireMe2")
            
        case 2:
            
            haikuImageView.image = UIImage(named: "inspireMe3")
            
        case 3:
            
            haikuImageView.image = UIImage(named: "inspireMe4")
            
        case 4:
            
            haikuImageView.image = UIImage(named: "inspireMe5")
            
        case 5:
            
            haikuImageView.image = UIImage(named: "inspireMe6")
            
        case 6:
            
            haikuImageView.image = UIImage(named: "inspireMe7")
            
        case 7:
            
            haikuImageView.image = UIImage(named: "inspireMe8")
            
        case 8:
            
            haikuImageView.image = UIImage(named: "inspireMe9")
            
        default:
            
            haikuImageView.image = UIImage(named: "inspireMe10")
    
            
        }
        
        stepThreeEnterHaiku()

    }
    

    //keyboard code
    
   
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }


    
    @IBAction func finishButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        setShareableHaikuImage()
        saveFinishedHaiku()
        view.endEditing(true)
        stepFourCongrats()
        stepOneCreateNewHaiku()
    }
    
    func saveFinishedHaiku() {
        
        let shareableHaikuImage = createShareableHaikuImage()
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uniqueHaikuUUID = NSUUID().UUIDString
        
        let currentImageRef = imagesRefForCurrentUser.child(uniqueHaikuUUID)
        
        if let data = UIImagePNGRepresentation(shareableHaikuImage) {
            currentImageRef.putData(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print(error)
                    print("uh-oh! trouble saving image")
                } else {
                    let downloadURL = metadata!.downloadURL

                    
                    let completedHaikusForCurrentUserRef = ClientService.completedHaikusRef.child(currentUserUID)
                    
                    let imageHaikuDownloadStringFromURL = downloadURL()?.absoluteString
                    
                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/imageURLString").setValue(imageHaikuDownloadStringFromURL)
                    
                    print("imageURL should be saved to backend now")
                    
                }
            }
        }
        
        let completedDetailVC = CompletedHaikuDetailViewController()
        presentViewController(completedDetailVC, animated: false) {
            completedDetailVC.completedHaikuDetailImageView.image = shareableHaikuImage
            completedDetailVC.animateButtons()
        }
        
        
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        let shareableHaikuImage = createShareableHaikuImage()
        let activityItemsArray = [shareableHaikuImage]
        let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
        //excluded iMessage from activity types because it was messing with keyboard UI with resigningFirstResponder stuff again.
        activityVC.excludedActivityTypes = [UIActivityTypeMessage]
        presentViewController(activityVC, animated: true, completion: nil)

    }
    
    func createShareableHaikuImage() -> UIImage {
        
        var shareableHaikuImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(shareableHaikuView.bounds.size, false, UIScreen.mainScreen().scale)
        
        shareableHaikuView.drawViewHierarchyInRect(shareableHaikuView.bounds, afterScreenUpdates: true)

        shareableHaikuImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return shareableHaikuImage
       
    }
    
    
    @IBAction func createANewHaikuButtonPressed(sender: AnyObject) {
        
       stepOneCreateNewHaiku()
        firstLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        secondLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        thirdLineHaikuTextView.backgroundColor = UIColor.whiteColor()
        
    }
    
    //commented out this function for now because it  doesn't really do much. better to enable pinch and zoom later instead
    
    //    @IBAction func haikuImageViewTapped(sender: UITapGestureRecognizer) {
    //        let imageView = sender.view as! UIImageView
    //        let newImageView = UIImageView(image: imageView.image)
    //        newImageView.frame = enterHaikuView.frame
    ////        newImageView.backgroundColor = .blackColor()
    //        newImageView.contentMode = .ScaleAspectFit
    //        newImageView.userInteractionEnabled = true
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(StartViewController.dismissFullscreenImage(_:)))
    //        newImageView.addGestureRecognizer(tap)
    //        self.view.addSubview(newImageView)
    //    }
    //
    //    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
    //        sender.view?.removeFromSuperview()
    //    }

    
    @IBAction func playWithOneFriendButtonPressed(sender: AnyObject) {
        
        selectOneFriend()
        
    }
    
    
    @IBAction func chooseFriendsBackButtonPressed(sender: AnyObject) {
        stepOneCreateNewHaiku()
        clearSelectedRows()
        arrayOfChosenFriends = []
        oneFriendOptionChosen = false
        twoFriendsOptionChosen = false
        enterHaikuContinueButton.hidden = true
        enterHaikuFinishButton.hidden = false
        
    }
    
    func clearSelectedRows() {
        if let indexPathsForSelectedRows = chooseFriendsTableView.indexPathsForSelectedRows {
            
            for indexPath in indexPathsForSelectedRows {
                self.chooseFriendsTableView.deselectRowAtIndexPath(indexPath, animated: true)
                if let cell = chooseFriendsTableView.cellForRowAtIndexPath(indexPath) {
                    cell.accessoryType = .None
                }
            }
        }

    }
    
    
    @IBAction func playWithTwoFriendsButtonPressed(sender: AnyObject) {
        selectTwoFriends()
    }
    
    func selectOneFriend() {
        setAllSubviewsToHidden()
        chooseFriendsLabel.text = "Choose one friend."
        chooseFriendsView.hidden = false
        chooseFriendsTableView.allowsMultipleSelection = false
        chooseFriendsTableView.allowsSelection = true
        oneFriendOptionChosen = true
        
    }
    
    func selectTwoFriends() {
        setAllSubviewsToHidden()
        chooseFriendsLabel.text = "Choose two friends."
        chooseFriendsView.hidden = false
        chooseFriendsTableView.allowsMultipleSelection = true
        twoFriendsOptionChosen = true
    }
    
    
    //table view stuff
    
    func fetchFriendsAndSetToDataSource() {
        print ("fetch friends data gets called")
        
        ClientService.getFriendUIDsForCurrentUser { (arrayOfFriendUIDs) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock  {
                let friendUIDArray = arrayOfFriendUIDs
                
                self.chooseFriendsTableViewDataSource.friendArray = []
                
                for friendUID in friendUIDArray {
                    ClientService.profileRef.child("\(friendUID)").queryOrderedByKey().observeEventType(.Value, withBlock: { (friend) in
                        print("FRIEND is \(friend)")
                        let uid = friend.value!.objectForKey("uid") as! String
                        let email = friend.value!.objectForKey("email") as! String
                        let username = friend.value!.objectForKey("username") as! String
                        let friend = User(username: username, email: email, uid: uid)
                        self.chooseFriendsTableViewDataSource.friendArray.append(friend)
                        
                        self.chooseFriendsTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                        
                    })
                }
            }
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
        //adjust height later
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            if selectedRows.count == 2 {
                let alertController = UIAlertController(title: "Choose only two friends.", message: "You can only choose two friends. To continue, please deselect any additional friends.", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            if selectedRows.count > 2 {
                return nil
            }
        }
        
        return indexPath
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select: \(indexPath.row)")
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as! FriendsTableViewCell
        
        if selectedCell.selected {
            selectedCell.accessoryType = .Checkmark
            if let email = selectedCell.friendsUsername.text {
                if self.arrayOfChosenFriends.contains(email) {
                    print("\(email) already added to array")
                } else {
                self.arrayOfChosenFriends.append(email)
                print(self.arrayOfChosenFriends)
                }
            }
        }
        
        
        
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if cell.selected {
//                cell.accessoryType = .Checkmark
//            }
//           
//        }
        
        }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendsTableViewCell
        cell.accessoryType = .None
        if let email = cell.friendsUsername.text {
            let updatedArray = self.arrayOfChosenFriends.filter {$0 != email}
            self.arrayOfChosenFriends = updatedArray
        }
        
//       if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if let email = cell.textLabel?.text {
//               let updatedArray = self.arrayOfChosenFriends.filter {$0 != email}
//               self.arrayOfChosenFriends = updatedArray
//            }
//            cell.accessoryType = .None
//        }
        
    }
    
    
    @IBAction func chooseFriendsContinueButtonPressed(sender: AnyObject) {
        
        print("choose friends continue button pressed")
        
        if oneFriendOptionChosen == true {
            
            if self.arrayOfChosenFriends.count == 1 {
                print("exactly one friend chosen, put code here for next step: friend chosen = \(self.arrayOfChosenFriends)")
                enterNewHaikuWithOneFriend()
                clearSelectedRows()
                
            } else {
                let alertController = UIAlertController(title: "Oops!", message: "Please select the appropriate number of friends.", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else if twoFriendsOptionChosen == true {
            
            if self.arrayOfChosenFriends.count == 2 {
                print("exactly one friend chosen, put code here for next step: friends chosen = = \(self.arrayOfChosenFriends)")
                enterNewHaikuWithTwoFriends()
                clearSelectedRows()
            } else {
                let alertController = UIAlertController(title: "Oops!", message: "Please select the appropriate number of friends.", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else {
            
            print("choose friends continue button chosen, but neither oneFriendOption nor twoFriendsOption is chosen, so what's happening here? YOU HAVE A BUG. FIX IT. SOMETHING WENT WRONG.")
        }
        
    }
    
    func enterNewHaikuWithOneFriend() {
        setAllSubviewsToHidden()
        choosePictureView.hidden = false
        
        enterHaikuFinishButton.hidden = true
        enterHaikuContinueButton.hidden = false
        
        if let email = arrayOfChosenFriends.first {
        firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables. Then continue."
        secondLineHaikuTextView.text = "\(email) enters second line of haiku."
        secondLineHaikuTextView.userInteractionEnabled = false
        
        thirdLineHaikuTextView.text = "After \(email) enters second line, you can write third line."
        thirdLineHaikuTextView.userInteractionEnabled = false
        
        secondLineHaikuTextView.textColor = UIColor.lightGrayColor()
        thirdLineHaikuTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func enterNewHaikuWithTwoFriends() {
        setAllSubviewsToHidden()
        choosePictureView.hidden = false
        
        enterHaikuFinishButton.hidden = true
        enterHaikuContinueButton.hidden = false
        
        if let firstFriendEmail = arrayOfChosenFriends.first, secondFriendEmail = arrayOfChosenFriends.last {
            firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables. Then press Continue."
            secondLineHaikuTextView.text = "\(firstFriendEmail) enters second line of haiku."
            secondLineHaikuTextView.userInteractionEnabled = false
            
            thirdLineHaikuTextView.text = "\(secondFriendEmail) enters third line of haiku."
            thirdLineHaikuTextView.userInteractionEnabled = false
            
            secondLineHaikuTextView.textColor = UIColor.lightGrayColor()
            thirdLineHaikuTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func enterHaikuContinueButtonPressed(sender: AnyObject) {
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        if arrayOfChosenFriends.count == 1 {
            
            saveActiveHaikuForTwoPlayers(currentUserUID)
            
           //create active haiku object and save to backend; then populate active tableview
        } else if arrayOfChosenFriends.count == 2 {
            
            saveActiveHaikuForThreePlayers(currentUserUID)
            //create active haiku object and save to backend; then populate active tableview
        }
    }
    
    
    func saveActiveHaikuForTwoPlayers(currentUserUID: String) {
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uuid = NSUUID().UUIDString
        
        let currentImageRef = imagesRefForCurrentUser.child(uuid)
        
        let haikuImage = haikuImageView.image
        
        if let data = UIImagePNGRepresentation(haikuImage!) {
            currentImageRef.putData(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print("uh-oh! trouble saving image")
                } else {
                    let imageDownloadURL = metadata!.downloadURL()
                    
                    let imageHaikuDownloadStringFromURL = imageDownloadURL!.absoluteString
                    
                    if let secondPlayerEmail = self.arrayOfChosenFriends.first {
                        ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(secondPlayerEmail).observeSingleEventOfType(.ChildAdded, withBlock: { (friendSnapshot) in
                            
                            let firstPlayerUID = currentUserUID
                            let thirdPlayerUID = currentUserUID
                            
                            let secondPlayerUID = friendSnapshot.value?.objectForKey("uid") as! String
                            
                            //save image and create imageHiakuDOwnloadURL
                            
                            let newActiveHaiku = ActiveHaiku(firstLineString: self.firstLineHaikuTextView.text, secondLineString: "Waiting on second player.", thirdLineString: "Write here after second player's turn.", imageURLString: imageHaikuDownloadStringFromURL, firstPlayerUUID: firstPlayerUID, secondPlayerUUID: secondPlayerUID, thirdPlayerUUID: thirdPlayerUID, uniqueHaikuUUID: uuid)
                            
                            ClientService.addActiveHaikuForPlayers(newActiveHaiku)
                            
                        } )}
                    
                    
                }
                
                
            }
        }
    }
    
    func saveActiveHaikuForThreePlayers(currentUserUID: String) {
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uuid = NSUUID().UUIDString
        
        let currentImageRef = imagesRefForCurrentUser.child(uuid)
        
        let haikuImage = haikuImageView.image
        
        if let data = UIImagePNGRepresentation(haikuImage!) {
            currentImageRef.putData(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print("uh-oh! trouble saving image")
                } else {
                    let imageDownloadURL = metadata!.downloadURL()
                    
                    let imageHaikuDownloadStringFromURL = imageDownloadURL!.absoluteString
                    
                    if let secondPlayerEmail = self.arrayOfChosenFriends.first {
                        ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(secondPlayerEmail).observeSingleEventOfType(.ChildAdded, withBlock: { (secondPlayerSnapshot) in
                            
                            let firstPlayerUID = currentUserUID
                            
                            let secondPlayerUID = secondPlayerSnapshot.value?.objectForKey("uid") as! String
                            
                            if let thirdPlayerEmail = self.arrayOfChosenFriends.last {
                                
                                ClientService.profileRef.queryOrderedByChild("email").queryEqualToValue(thirdPlayerEmail).observeSingleEventOfType(.ChildAdded, withBlock: { (thirdPlayerSnapshot) in
                                    
                                    let thirdPlayerUID = thirdPlayerSnapshot.value?.objectForKey("uid") as! String
                                    
                                    let newActiveHaiku = ActiveHaiku(firstLineString: self.firstLineHaikuTextView.text, secondLineString: "Waiting on second player.", thirdLineString: "Write here after second player's turn.", imageURLString: imageHaikuDownloadStringFromURL, firstPlayerUUID: firstPlayerUID, secondPlayerUUID: secondPlayerUID, thirdPlayerUUID: thirdPlayerUID, uniqueHaikuUUID: uuid)
                                    
                                    ClientService.addActiveHaikuForPlayers(newActiveHaiku)
                                    
                                    
                                })
                                
                                
                            }
                            
                            //save image and create imageHiakuDOwnloadURL
                            
                            
                        } )}
                    
                    
                }
                
                
            }
        }
    }


        // this code is really good for saving active Haikus in Kubazar! but for minikubazar, you can do something much simpler. just save screenshot to backend. for completed Haikus in Kubazar, you can also just save the screenshot to the backend.
        
    
        
//        let currentUserUID = ClientService.getCurrentUserUID()
//        
//        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
//        
//        let uuid = NSUUID().UUIDString
//        
//        let currentImageRef = imagesRefForCurrentUser.child(uuid)
//        
//        let haikuImage = haikuImageView.image
//        if let data = UIImagePNGRepresentation(haikuImage!) {
//            currentImageRef.putData(data, metadata: nil) {
//                metadata, error in
//                if (error != nil) {
//                    print("uh-oh! trouble saving image")
//                } else {
//                    let downloadURL = metadata!.downloadURL
//                    let newHaiku = Haiku(firstLineHaiku: firstLine, secondLineHaiku: secondLine, thirdLineHaiku: thirdLine, imageHaikuDownloadURL: downloadURL(), uuid: uuid)
//                    
//                    let completedHaikusForCurrentUserRef = ClientService.completedHaikusRef.child(currentUserUID)
//                    
//                    let uniqueHaikuUUID = newHaiku.uuid
//                    
//                    self.recentlyFinishedHaikuUID = uniqueHaikuUUID
//                    
//                    let firstLineHaiku = newHaiku.firstLineHaiku
//                    let secondLineHaiku = newHaiku.secondLineHaiku
//                    let thirdLineHaiku = newHaiku.thirdLineHaiku
//                    let imageHaikuDownloadURL = newHaiku.imageHaikuDownloadURL
//                    
//                    let imageHaikuDownloadStringFromURL = imageHaikuDownloadURL.absoluteString
//                    
//                    
//                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/firstLineHaiku").setValue(firstLineHaiku)
//                    
//                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/secondLineHaiku").setValue(secondLineHaiku)
//                    
//                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/thirdLineHaiku").setValue(thirdLineHaiku)
//                    
//                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/imageURLString").setValue(imageHaikuDownloadStringFromURL)
//                    
//                }
//            }
//        }
        
 //   }

}
