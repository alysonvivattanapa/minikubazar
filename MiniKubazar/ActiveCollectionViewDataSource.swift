//
//  ActiveCollectionViewDataSource.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/27/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import Firebase

class ActiveCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var urlStringArray = [String]()
    
    var activeHaikus = [ActiveHaiku]()
    
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeHaikus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "activeCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ActiveCollectionViewCell
        
        let activeHaiku = activeHaikus[(indexPath as NSIndexPath).row]
        
        let currentUserUID = ClientService.getCurrentUserUID()
        
        if let secondPlayer = activeHaiku.secondPlayerUUID, let secondLine = activeHaiku.secondLineString {
            if secondPlayer == currentUserUID && secondLine.contains("enters second line of haiku.") {
                
                cell.updateWithLabelText("It's your turn!")
            }
        }
        
        if let thirdPlayer = activeHaiku.thirdPlayerUUID, let secondLine = activeHaiku.secondLineString, let thirdLine = activeHaiku.thirdLineString {
            if thirdPlayer == currentUserUID && !secondLine.contains("enters second line of haiku") && thirdLine.contains("enters third line of haiku.") {
                
                cell.updateWithLabelText("It's your turn!"
                )
            }
        }
        
        
        if let imageURL = activeHaiku.imageURLString {
            
            let cachedImage = imageCache.object(forKey: imageURL as AnyObject)
            
            if ((cachedImage) != nil) {
                if let image = cachedImage as? UIImage {
                    cell.updateWithImage(image)
                }
            } else {
                DispatchQueue.global().async {
                    
                    let haikuImageRef = FIRStorage.storage().reference(forURL: imageURL)
                    haikuImageRef.data(withMaxSize: 1 * 3000 * 3000) { (data, error) in
                        if (error != nil) {
                            print(error)
                            print("something wrong with active haiku image from storage. check active collection view data source code")
                        } else {
                            if let haikuImage = UIImage(data: data!) {
                                
                                self.imageCache.setObject(haikuImage, forKey: imageURL as AnyObject)
                                
                                DispatchQueue.main.async {
                                    
                                    cell.updateWithImage(haikuImage)
                                }
                            }
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
            return cell
        }
    
    

}
