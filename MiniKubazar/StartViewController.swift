//
//  StartViewController.swift
//  Kubazar
//
//  Created by Alyson Vivattanapa on 7/13/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    
    @IBOutlet weak var firstKubazarMascot: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
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
    
    var animator: UIDynamicAnimator!
    
    var gravity: UIGravityBehavior!
    
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLineHaikuTextView.delegate = self
        secondLineHaikuTextView.delegate = self
        thirdLineHaikuTextView.delegate = self
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
    stepOneCreateNewHaiku()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        firstLineHaikuTextView.text = "Enter first line of haiku: 5 syllables"
        secondLineHaikuTextView.text = "Enter second line of haiku: 7 syllables"
        thirdLineHaikuTextView.text = "Enter third line of haiku: 5 syllables"
        firstLineHaikuTextView.textColor = UIColor.lightGrayColor()
        secondLineHaikuTextView.textColor = UIColor.lightGrayColor()
        thirdLineHaikuTextView.textColor = UIColor.lightGrayColor()
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
       
        startButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        setAllViewAlphasToZero()
        createNewHaikuView.alpha = 1
       
        animator = UIDynamicAnimator(referenceView: self.createNewHaikuView)
        gravity = UIGravityBehavior(items: [firstKubazarMascot])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [firstKubazarMascot])
        collision.addBoundaryWithIdentifier("createNewHaikuLabel", forPath: UIBezierPath(rect: createNewHaikuLabel.frame))
        
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehavior = UIDynamicItemBehavior(items: [firstKubazarMascot])
        itemBehavior.elasticity = 0.7
        animator.addBehavior(itemBehavior)
        
        UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 9, options: .AllowUserInteraction, animations: {
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
    }
    
   
    
    //refactor these steps functions, pass view to show
    //hide all views function
    
    
    func stepTwoChoosePicture() {
        setAllViewAlphasToZero()
        choosePictureView.alpha = 1
    }
    
    @IBAction func choosePictureBackButtonPressed(sender: AnyObject) {
        stepOneCreateNewHaiku()
    }
    
    
    func stepThreeEnterHaiku() {
        setAllViewAlphasToZero()
        enterHaikuView.alpha = 1
    }
    
    func stepFourCongrats() {
        setAllViewAlphasToZero()
        congratsView.alpha = 1
    }
    
    
    @IBAction func startOverButtonPressed(sender: AnyObject) {
        stepOneCreateNewHaiku()
    }
    
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        stepTwoChoosePicture()
    }
    
    
    @IBAction func thirdBackButtonPressed(sender: AnyObject) {
//        haikuFirstLine.text? = ""
//        haikuSecondLine.text? = ""
//        haikuThirdLine.text? = ""
        setAllViewAlphasToZero()
        choosePictureView.alpha = 1
    }
    
    
    func setAllViewAlphasToZero() {
        createNewHaikuView.alpha = 0
        choosePictureView.alpha = 0
        enterHaikuView.alpha = 0
        congratsView.alpha = 0
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
        
// cannot specify custom source type for image picker. may have to implement collection view and choose images from database in collection view. for now, button does nothing!

    }
    

//    @IBAction func startButtonPressed(sender: AnyObject) {
    
        /*
         
         save image example code, write to Firebase somehow?:
         
         var imageData = UIImageJPEGRepresentation(imagePicked.image, 0.6)
         var compressedJPGImage = UIImage(data: imageData)
         UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
         
         */
        
        //save active haiku to firebase...model object? gahh...first player, second player, third player OR first player, second player, third player = first player
    
  //  }
    
  
    
    // write haiku to Firebase...Firebase generates unique ID for each haiku post:
    /*
 let postRef = ref.childByAppendingPath("posts")
 let post1 = ["author": "gracehop", "title": "Announcing COBOL, a New Programming Language"]
 let post1Ref = postRef.childByAutoId()
 post1Ref.setValue(post1)
 
 let post2 = ["author": "alanisawesome", "title": "The Turing Machine"]
 let post2Ref = postRef.childByAutoId()
 post2Ref.setValue(post2)
     
 postID = post1Ref.key 
  // calling .key gets the unique ID of that post
 */

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

    
  
    @IBAction func haikuImageViewTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = enterHaikuView.frame
//        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(StartViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    
    @IBAction func finishButtonPressed(sender: AnyObject) {
        saveHaiku()
        stepFourCongrats()
    }
    
    func saveHaiku() {
        
        let firstLine = firstLineHaikuTextView.text
        let secondLine = secondLineHaikuTextView.text
        let thirdLine = thirdLineHaikuTextView.text
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        let imagesRefForCurrentUser = ClientService.imagesRef.child(currentUserUID)
        
        let uuid = NSUUID().UUIDString
        
        let currentImageRef = imagesRefForCurrentUser.child(uuid)
        
        let path = currentImageRef.fullPath
        
        let haikuImage = haikuImageView.image
        if let data = UIImagePNGRepresentation(haikuImage!) {
        currentImageRef.putData(data, metadata: nil) {
                metadata, error in
                if (error != nil) {
                    print("uh-oh! trouble saving image")
                } else {
                    let downloadURL = metadata!.downloadURL
                    var newHaiku = Haiku(firstLineHaiku: firstLine, secondLineHaiku: secondLine, thirdLineHaiku: thirdLine, imageHaikuDownloadURL: downloadURL(), uuid: uuid)
                    
                    let completedHaikusForCurrentUserRef = ClientService.completedHaikusRef.child(currentUserUID)
                    
                    let uniqueHaikuUUID = newHaiku.uuid
                    let firstLineHaiku = newHaiku.firstLineHaiku
                    let secondLineHaiku = newHaiku.secondLineHaiku
                    let thirdLineHaiku = newHaiku.thirdLineHaiku
                    let imageHaikuDownloadURL = newHaiku.imageHaikuDownloadURL
                    
                    let imageHaikuDownloadStringFromURL = imageHaikuDownloadURL.absoluteString
                    
                    
                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/firstLineHaiku").setValue(firstLineHaiku)
                    
                    completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/secondLineHaiku").setValue(secondLineHaiku)
                    
                     completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/thirdLineHaiku").setValue(thirdLineHaiku)
                    
                     completedHaikusForCurrentUserRef.child("\(uniqueHaikuUUID)/imageURLString").setValue(imageHaikuDownloadStringFromURL)
                    
                    
                }
            }
        }
        
        
        
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
}
