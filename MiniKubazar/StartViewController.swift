//
//  StartViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate {

    @IBOutlet weak var firstKubazarMascot: UIImageView!

    @IBOutlet weak var byYourselfButton: UIButton!
    
    @IBOutlet weak var playWithOneFriendButton: UIButton!
    
    @IBOutlet weak var playWithTwoFriendsButton: UIButton!
    
    
    @IBOutlet weak var createNewHaikuView: UIView!
    
    @IBOutlet weak var createNewHaikuLabel: UILabel!
    
    @IBOutlet weak var choosePictureView: UIView!
    
    @IBOutlet weak var enterHaikuView: UIView!
    
    @IBOutlet weak var firstLineHaikuTextView: UITextView!
    
    @IBOutlet weak var secondLineHaikuTextView: UITextView!
    
    @IBOutlet weak var thirdLineHaikuTextView: UITextView!
    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    
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
    
    @IBOutlet weak var instructionsView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       instructionsView.layer.cornerRadius = 25
        
        firstLineHaikuTextView.delegate = self
        secondLineHaikuTextView.delegate = self
        thirdLineHaikuTextView.delegate = self
        
        chooseFriendsTableView.dataSource = chooseFriendsTableViewDataSource
        chooseFriendsTableView.delegate = self
        
        self.fetchFriendsAndSetToDataSource()
        
        let friendsNib = UINib.init(nibName: "FriendsTableViewCell", bundle: nil)
        chooseFriendsTableView.register(friendsNib, forCellReuseIdentifier: "friendsCell")
        
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    self.stepOneCreateNewHaiku()
        
//    oneFriendOptionChosen = false
//    twoFriendsOptionChosen = false
//    
        
        firstLineHaikuTextView.textContainer.maximumNumberOfLines = 1
        firstLineHaikuTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        secondLineHaikuTextView.textContainer.maximumNumberOfLines = 1
        secondLineHaikuTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        thirdLineHaikuTextView.textContainer.maximumNumberOfLines = 1
        thirdLineHaikuTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let reachability = Reachability()!
        
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

        if createNewHaikuView.isHidden == false {
            startAnimation()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
            textView.backgroundColor = UIColor(red: 90.0/255, green: 191.0/255, blue: 188.0/255, alpha: 1)
//            textView.layer.cornerRadius = 5
            textView.clipsToBounds = true
     //   }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stepOneCreateNewHaiku() {
        
        setAllSubviewsToHidden()
        createNewHaikuView.isHidden = false
        startAnimation()
        oneFriendOptionChosen = false
        twoFriendsOptionChosen = false
//        disableEditableTextViews()
    }
    
    func enableAllEditableTextViews() {
        firstLineHaikuTextView.isEditable = true
        secondLineHaikuTextView.isEditable = true
        thirdLineHaikuTextView.isEditable = true
    }
    
    func resetTextViews() {
        firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables"
        secondLineHaikuTextView.text = "Enter second line of haiku: 7 syllables"
        thirdLineHaikuTextView.text = "Enter third line of haiku: 5 syllables"
        firstLineHaikuTextView.textColor = UIColor.lightGray
        secondLineHaikuTextView.textColor = UIColor.lightGray
        thirdLineHaikuTextView.textColor = UIColor.lightGray
        firstLineHaikuTextView.backgroundColor = UIColor.white
        secondLineHaikuTextView.backgroundColor = UIColor.white
        thirdLineHaikuTextView.backgroundColor = UIColor.white
    }
    
    func disableEditableTextViews() {
        firstLineHaikuTextView.isEditable = false
        secondLineHaikuTextView.isEditable = false
        thirdLineHaikuTextView.isEditable = false
    }
    
    func startAnimation() {
        byYourselfButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        playWithOneFriendButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        playWithTwoFriendsButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        firstKubazarMascot.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        createNewHaikuLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        
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
        
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
            self.byYourselfButton.transform = CGAffineTransform.identity
            self.playWithOneFriendButton.transform = CGAffineTransform.identity
            self.playWithTwoFriendsButton.transform = CGAffineTransform.identity
            self.firstKubazarMascot.transform = CGAffineTransform.identity
            self.createNewHaikuLabel.transform = CGAffineTransform.identity
            }, completion: nil)
        
    }
    
    func imageViewAnimation(_ imageView: UIImageView){
        imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
            imageView.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func buttonAnimation(_ button: UIButton){
        button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .allowUserInteraction, animations: {
            button.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func stepTwoChoosePicture() {
        setAllSubviewsToHidden()
        choosePictureView.isHidden = false
        buttonAnimation(cameraButton)
        buttonAnimation(cameraRollButton)
        buttonAnimation(inspireMeButton)
//        enterHaikuContinueButton.isHidden = true
//        enterHaikuFinishButton.isHidden = false
    }
    
    @IBAction func choosePictureBackButtonPressed(_ sender: AnyObject) {
        stepOneCreateNewHaiku()
    }
    
    
    func stepThreeEnterHaiku() {
        setAllSubviewsToHidden()
        enterHaikuView.isHidden = false
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
    
        
//    @IBAction func startButtonPressed(sender: AnyObject) {
//        stepTwoChoosePicture()
//    }
    
    @IBAction func byYourselfButtonPressed(_ sender: AnyObject) {
        resetTextViews()
        enableAllEditableTextViews()
        
        instructionsView.isHidden = true
        enterHaikuContinueButton.isHidden = true
        enterHaikuFinishButton.isHidden = false
        stepTwoChoosePicture()
    }
    
    @IBAction func thirdBackButtonPressed(_ sender: AnyObject) {

       stepTwoChoosePicture()
       self.view.endEditing(true)
    }
    
    
    func setAllSubviewsToHidden() {
        createNewHaikuView.isHidden = true
        choosePictureView.isHidden = true
        enterHaikuView.isHidden = true
        congratsView.isHidden = true
        chooseFriendsView.isHidden = true
    }
    
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cameraRollButtonPressed(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        haikuImageView.image = image
        self.dismiss(animated: true, completion: nil);
        stepThreeEnterHaiku()
   
        
    }

    
    
    @IBAction func inspireMeButtonPressed(_ sender: AnyObject) {
        
        let random = arc4random_uniform(9)
        
        switch random {
        case 0:
           
             haikuImageView.image = UIImage(named: "inspire1")
            
        case 1:
            
            haikuImageView.image = UIImage(named: "inspire2")
            
        case 2:
            
            haikuImageView.image = UIImage(named: "inspire3")
            
        case 3:
            
            haikuImageView.image = UIImage(named: "inspire4")
            
        case 4:
            
            haikuImageView.image = UIImage(named: "inspire5")
            
        case 5:
            
            haikuImageView.image = UIImage(named: "inspire6")
            
        case 6:
            
            haikuImageView.image = UIImage(named: "inspire7")
            
        case 7:
            
            haikuImageView.image = UIImage(named: "inspire8")
            
        case 8:
            
            haikuImageView.image = UIImage(named: "inspire9")
            
        default:
            
            haikuImageView.image = UIImage(named: "inspire10")
    
            
        }
        
        stepThreeEnterHaiku()

    }
    

    //keyboard code
    
   
    
    func keyboardWillHide(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func keyboardWillShow(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }


    
    @IBAction func finishButtonPressed(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if firstLineHaikuTextView.text == "Enter first line of haiku: 5 syllables" ||
        secondLineHaikuTextView.text == "Enter second line of haiku: 7 syllables" ||
            thirdLineHaikuTextView.text == "Enter third line of haiku: 5 syllables" || firstLineHaikuTextView.text == "" || secondLineHaikuTextView.text == "" || thirdLineHaikuTextView.text == "" {
            // prevent player from entering haiku without editing all three lines
            self.present(Alerts.showErrorMessage("Please enter a full haiku to finish."), animated: true, completion: nil)
            
        } else {
        
        showCompletedDetailView()
        setShareableHaikuImage()
        saveFinishedHaiku()
        view.endEditing(true)
//        stepFourCongrats()
        stepOneCreateNewHaiku()
        }
    }
    
    func showCompletedDetailView() {
        let completedDetailVC = CompletedHaikuDetailViewController()
        
        self.present(completedDetailVC, animated: false) {
           
            if let firstLine = self.firstLineHaikuTextView.text, let secondLine =
                self.secondLineHaikuTextView.text, let thirdLine =
                self.thirdLineHaikuTextView.text {
            completedDetailVC.completedHaikuDetailImageView.image = self.finishedImageView.image
            completedDetailVC.firstLineLabel.text = firstLine
            completedDetailVC.secondLineLabel.text = secondLine
            completedDetailVC.thirdLineLabel.text = thirdLine
            completedDetailVC.dotDotDotButton.isHidden = true
            }
            
            completedDetailVC.animateButtons()
        }
        
    }
    
    func saveFinishedHaiku() {
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uniqueHaikuUUID = UUID().uuidString
        
        let currentImageRef = imagesRefForCurrentUser.child(uniqueHaikuUUID)
        
        if let data = UIImagePNGRepresentation(finishedImageView.image!) {
            currentImageRef.put(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print(error)
                    print("uh-oh! trouble saving image")
                } else {
                    
                    
                    let downloadURL = metadata!.downloadURL
                    let imageHaikuDownloadStringFromURL = downloadURL()?.absoluteString
                    
                    let newCompletedHaikusForCurrentUserRef = ClientService.newCompletedHaikusRef.child(currentUserUID)
                    
                    let currentTimestamp = FIRServerValue.timestamp() as AnyObject
                    
                    if let firstLine = self.firstLineHaikuTextView.text, let secondLine =
                        self.secondLineHaikuTextView.text, let thirdLine =
                        self.thirdLineHaikuTextView.text {
                        let newHaiku = ActiveHaiku(firstLineString: firstLine, secondLineString: secondLine, thirdLineString: thirdLine, imageURLString: imageHaikuDownloadStringFromURL, firstPlayerUUID: currentUserUID, secondPlayerUUID: currentUserUID, thirdPlayerUUID: currentUserUID, uniqueHaikuUUID: uniqueHaikuUUID, timestamp: currentTimestamp)
                        
                        let newHaikuDictionary: NSDictionary = ["firstLineString": newHaiku.firstLineString, "secondLineString": newHaiku.secondLineString, "thirdLineString": newHaiku.thirdLineString, "imageURLString": newHaiku.imageURLString, "firstPlayerUUID": newHaiku.firstPlayerUUID, "secondPlayerUUID": newHaiku.secondPlayerUUID, "thirdPlayerUUID": newHaiku.thirdPlayerUUID, "uniqueHaikuUUID": newHaiku.uniqueHaikuUUID, "timestamp": newHaiku.timestamp]
                        
                        newCompletedHaikusForCurrentUserRef.child(uniqueHaikuUUID).setValue(newHaikuDictionary)
                        
                    }
                    
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        
        let shareableHaikuImage = createShareableHaikuImage()
        let activityItemsArray = [shareableHaikuImage]
        let activityVC = UIActivityViewController.init(activityItems: activityItemsArray, applicationActivities: nil)
        //excluded iMessage from activity types because it was messing with keyboard UI with resigningFirstResponder stuff again.
        activityVC.excludedActivityTypes = [UIActivityType.message]
        present(activityVC, animated: true, completion: nil)

    }
    
    func createShareableHaikuImage() -> UIImage {
        
        var shareableHaikuImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(shareableHaikuView.bounds.size, false, UIScreen.main.scale)
        
        shareableHaikuView.drawHierarchy(in: shareableHaikuView.bounds, afterScreenUpdates: true)

        shareableHaikuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return shareableHaikuImage
       
    }
    
    
    @IBAction func createANewHaikuButtonPressed(_ sender: AnyObject) {
        
       stepOneCreateNewHaiku()
//        firstLineHaikuTextView.backgroundColor = UIColor.white
//        secondLineHaikuTextView.backgroundColor = UIColor.white
//        thirdLineHaikuTextView.backgroundColor = UIColor.white
        
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

    
    @IBAction func playWithOneFriendButtonPressed(_ sender: AnyObject) {
        resetTextViews()
        instructionsView.isHidden = false
        disableEditableTextViews()
        firstLineHaikuTextView.isEditable = true
        
        selectOneFriend()
        
    }
    
    
    @IBAction func chooseFriendsBackButtonPressed(_ sender: AnyObject) {
        stepOneCreateNewHaiku()
        clearSelectedRows()
        arrayOfChosenFriends = []
        oneFriendOptionChosen = false
        twoFriendsOptionChosen = false
//        enterHaikuContinueButton.isHidden = true
//        enterHaikuFinishButton.isHidden = false
        
    }
    
    func clearSelectedRows() {
        if let indexPathsForSelectedRows = chooseFriendsTableView.indexPathsForSelectedRows {
            
            for indexPath in indexPathsForSelectedRows {
                self.chooseFriendsTableView.deselectRow(at: indexPath, animated: true)
                if let cell = chooseFriendsTableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .none
                }
            }
        }

    }
    
    
    @IBAction func playWithTwoFriendsButtonPressed(_ sender: AnyObject) {
        resetTextViews()
        
        instructionsView.isHidden = false
        disableEditableTextViews()
        firstLineHaikuTextView.isEditable = true
        
        selectTwoFriends()
    }
    
    func selectOneFriend() {
        setAllSubviewsToHidden()
        arrayOfChosenFriends = []
        chooseFriendsLabel.text = "Choose one friend."
        chooseFriendsView.isHidden = false
        chooseFriendsTableView.allowsMultipleSelection = false
        chooseFriendsTableView.allowsSelection = true
        oneFriendOptionChosen = true
        twoFriendsOptionChosen = false
        
    }
    
    func selectTwoFriends() {
        setAllSubviewsToHidden()
        arrayOfChosenFriends = []
        chooseFriendsLabel.text = "Choose two friends."
        chooseFriendsView.isHidden = false
        chooseFriendsTableView.allowsMultipleSelection = true
        twoFriendsOptionChosen = true
        oneFriendOptionChosen = false
    }
    
    
    //table view stuff
    
    func fetchFriendsAndSetToDataSource() {
        print ("fetch friends data gets called")
        
        ClientService.getFriendUIDsForCurrentUser { (arrayOfFriendUIDs) in
            
            OperationQueue.main.addOperation  {
                let friendUIDArray = arrayOfFriendUIDs
                
                self.chooseFriendsTableViewDataSource.friendArray = []
                
                for friendUID in friendUIDArray {
                    ClientService.profileRef.child("\(friendUID)").queryOrderedByKey().observe(.value, with: { (friend) in
                        print("FRIEND is \(friend)")
                        let uid = (friend.value! as AnyObject).object(forKey: "uid") as! String
                        let email = (friend.value! as AnyObject).object(forKey: "email") as! String
                        let username = (friend.value! as AnyObject).object(forKey: "username") as! String
                        let friend = User(username: username, email: email, uid: uid)
                        self.chooseFriendsTableViewDataSource.friendArray.append(friend)
                        
                        self.chooseFriendsTableView.reloadSections(IndexSet(integer: 0), with: .none)
                        
                    })
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        //adjust height later
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            if selectedRows.count == 2 {
                let alertController = UIAlertController(title: "Choose only two friends.", message: "You can only choose two friends. To continue, please deselect any additional friends.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if selectedRows.count > 2 {
                return nil
            }
        }
        
        return indexPath
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select: \((indexPath as NSIndexPath).row)")
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        
            selectedCell.accessoryType = .checkmark
            if let email = selectedCell.friendsUsername.text {
                if self.arrayOfChosenFriends.contains(email) {
                    print("\(email) already added to array")
                } else {
                self.arrayOfChosenFriends.append(email)
                print(self.arrayOfChosenFriends)
                }
            
        }
        
        
        
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if cell.selected {
//                cell.accessoryType = .Checkmark
//            }
//           
//        }
        
        }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        cell.accessoryType = .none
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
    
    func enterNewHaikuWithOneFriend() {
        setAllSubviewsToHidden()
        choosePictureView.isHidden = false
        
        enterHaikuFinishButton.isHidden = true
        enterHaikuContinueButton.isHidden = false
        
        if let email = arrayOfChosenFriends.first {
            
            firstLineHaikuTextView.backgroundColor = UIColor.yellow
            
            firstLineHaikuTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
            
            firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables."
            
            secondLineHaikuTextView.text = "\(email) enters second line of haiku."

            thirdLineHaikuTextView.text = "Then you can enter third line."
            
        }
    }
    
    
    func enterNewHaikuWithTwoFriends() {
        setAllSubviewsToHidden()
        choosePictureView.isHidden = false
        
        enterHaikuFinishButton.isHidden = true
        enterHaikuContinueButton.isHidden = false
        
        if let firstFriendEmail = arrayOfChosenFriends.first, let secondFriendEmail = arrayOfChosenFriends.last {
            
            firstLineHaikuTextView.backgroundColor = UIColor.yellow
            
            firstLineHaikuTextView.textColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
            
            firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables."
            
            secondLineHaikuTextView.text = "\(firstFriendEmail) enters second line of haiku."

            thirdLineHaikuTextView.text = "\(secondFriendEmail) enters third line of haiku."
            

        }
    }
    
    
    
    @IBAction func chooseFriendsContinueButtonPressed(_ sender: AnyObject) {
        
        print("one friend option chosen = \(oneFriendOptionChosen)")
        print("two friend options chosen = \(twoFriendsOptionChosen)")
        
        print("choose friends continue button pressed")
        
        if oneFriendOptionChosen == true && self.arrayOfChosenFriends.count == 1 {
                print("exactly one friend chosen, put code here for next step: friend chosen = \(self.arrayOfChosenFriends)")
                enterNewHaikuWithOneFriend()
                clearSelectedRows()
            
        } else if twoFriendsOptionChosen == true && self.arrayOfChosenFriends.count == 2 {
            print(arrayOfChosenFriends)
                                print("exactly two friends chosen, put code here for next step: friends chosen = \(self.arrayOfChosenFriends)")
                                enterNewHaikuWithTwoFriends()
                                clearSelectedRows()
                            } else {
                                let alertController = UIAlertController(title: "Oops!", message: "Please select the appropriate number of friends.", preferredStyle: .alert)
                                let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(okayAction)
                                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func enterHaikuContinueButtonPressed(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        print("enterHaikuContinueButton pressed")
        
        if firstLineHaikuTextView.text.contains("Enter first line of haiku: 5 syllables") {
            self.present(Alerts.showErrorMessage("Please enter first line of haiku to continue."), animated: true, completion: nil)
            
        } else {
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        if arrayOfChosenFriends.count == 1 {
            
        saveActiveHaikuForTwoPlayers(currentUserUID)
            
            if let oneFriend = self.arrayOfChosenFriends.first {
            
            self.present(Alerts.showSuccessMessage("You started a haiku with \(oneFriend). Tap on the Bazar tab to see your active haikus."), animated: true, completion: nil)
            }
            
//            showCompletedDetailView()
//            setShareableHaikuImage()
            view.endEditing(true)
            stepOneCreateNewHaiku()
            
           //create active haiku object and save to backend; then populate active tableview
        } else if arrayOfChosenFriends.count == 2 {
            
            saveActiveHaikuForThreePlayers(currentUserUID)
            //create active haiku object and save to backend; then populate active tableview
            if let firstFriend = self.arrayOfChosenFriends.first, let secondFriend = self.arrayOfChosenFriends.last {
            self.present(Alerts.showSuccessMessage("You started a haiku with \(firstFriend) and \(secondFriend). Tap on the Bazar tab to see your active haikus."), animated: true, completion: nil)
                showCompletedDetailView()
                setShareableHaikuImage()
                view.endEditing(true)
                stepOneCreateNewHaiku()
            }
            
        }
    }
    }
    
    func saveActiveHaikuForTwoPlayers(_ currentUserUID: String) {
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uuid = UUID().uuidString
        
        let currentImageRef = imagesRefForCurrentUser.child(uuid)
        
        let haikuImage = haikuImageView.image
        
        if let data = UIImagePNGRepresentation(haikuImage!) {
            currentImageRef.put(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print("uh-oh! trouble saving image")
                } else {
                    let imageDownloadURL = metadata!.downloadURL()
                    
                    let imageHaikuDownloadStringFromURL = imageDownloadURL!.absoluteString
                    
                    if let secondPlayerEmail = self.arrayOfChosenFriends.first {
                        ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: secondPlayerEmail).observeSingleEvent(of: .childAdded, with: { (friendSnapshot) in
                            
                            let firstPlayerUID = currentUserUID
                            let thirdPlayerUID = currentUserUID
                            
                            let friendSnapshotValue = friendSnapshot.value as? NSDictionary
                            
                            let secondPlayerUID = friendSnapshotValue?.object(forKey: "uid") as? String
                            
                            let currentUserEmail = ClientService.getCurrentUserEmail()
                            
                            let currentTimestamp = FIRServerValue.timestamp() as AnyObject
                            //save image and create imageHiakuDOwnloadURL
                            
                            let newActiveHaiku = ActiveHaiku(firstLineString: self.firstLineHaikuTextView.text, secondLineString: "\(secondPlayerEmail) enters second line of haiku.", thirdLineString: "\(currentUserEmail) enters third line of haiku.", imageURLString: imageHaikuDownloadStringFromURL, firstPlayerUUID: firstPlayerUID, secondPlayerUUID: secondPlayerUID, thirdPlayerUUID: thirdPlayerUID, uniqueHaikuUUID: uuid, timestamp: currentTimestamp)
                            
                            ClientService.addActiveHaikuForPlayers(newActiveHaiku)
                            
                        } )}
                    
                    
                }
                
                
            }
        }
    }
    
    func saveActiveHaikuForThreePlayers(_ currentUserUID: String) {
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uuid = UUID().uuidString
        
        let currentImageRef = imagesRefForCurrentUser.child(uuid)
        
        let haikuImage = haikuImageView.image
        
        if let data = UIImagePNGRepresentation(haikuImage!) {
            currentImageRef.put(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print("uh-oh! trouble saving image")
                } else {
                    let imageDownloadURL = metadata!.downloadURL()
                    
                    let imageHaikuDownloadStringFromURL = imageDownloadURL!.absoluteString
                    
                    if let secondPlayerEmail = self.arrayOfChosenFriends.first {
                        ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: secondPlayerEmail).observeSingleEvent(of: .childAdded, with: { (secondPlayerSnapshot) in
                            
                            let firstPlayerUID = currentUserUID
                            
                            let secondPlayerSnapshotValue = secondPlayerSnapshot.value as? NSDictionary
                            
                             let secondPlayerUID = secondPlayerSnapshotValue?.object(forKey: "uid") as? String
                            
                            if let thirdPlayerEmail = self.arrayOfChosenFriends.last {
                                
                                ClientService.profileRef.queryOrdered(byChild: "email").queryEqual(toValue: thirdPlayerEmail).observeSingleEvent(of: .childAdded, with: { (thirdPlayerSnapshot) in
                                    
                                    
                                    let thirdPlayerSnapshotValue = thirdPlayerSnapshot.value as? NSDictionary
                                    
                                    let thirdPlayerUID = thirdPlayerSnapshotValue?.object(forKey: "uid") as? String
                                    
                                    let currentTimestamp = FIRServerValue.timestamp() as AnyObject
                                    
                                    let newActiveHaiku = ActiveHaiku(firstLineString: self.firstLineHaikuTextView.text, secondLineString: "\(secondPlayerEmail) enters second line of haiku.", thirdLineString: "\(thirdPlayerEmail) enters third line of haiku.", imageURLString: imageHaikuDownloadStringFromURL, firstPlayerUUID: firstPlayerUID, secondPlayerUUID: secondPlayerUID, thirdPlayerUUID: thirdPlayerUID, uniqueHaikuUUID: uuid, timestamp: currentTimestamp)
                                    
                                    ClientService.addActiveHaikuForPlayers(newActiveHaiku)
                                    
                                    
                                })
                                
                                
                            }
                            
                        } )}
                    
                    
                }
                
                
            }
        }
    }
    
   

}
