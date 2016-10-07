//
//  CompletedCollectionViewDataSource.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/14/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import Firebase

class CompletedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var urlStringArray = [String]()
    
    var completedHaikus = [ActiveHaiku]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return completedHaikus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "completedCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CompletedHaikusCollectionViewCell
        
        let completedHaiku = completedHaikus[(indexPath as NSIndexPath).row]
        
        let firstLine = completedHaiku.firstLineString
        
        if let imageURL = completedHaiku.imageURLString {
            
            let cachedImage = imageCache.object(forKey: imageURL as AnyObject)
            
            if ((cachedImage) != nil) {
                if let newCachedImage = cachedImage as? UIImage {
                    cell.updateWithImage(newCachedImage)
                }
            } else {
                
                DispatchQueue.global().async {
                    
                    let haikuImageRef = FIRStorage.storage().reference(forURL: imageURL)
                    haikuImageRef.data(withMaxSize: 1 * 3000 * 3000) { (data, error) in
                        if (error != nil) {
                            print(error)
                            print("something wrong with completed haiku image from storage. check completed collection view data source code")
                        } else {
                            if let haikuImage = UIImage(data: data!) {
                                
                                cell.firstHaikuLine.text = firstLine
                                
                                self.imageCache.setObject(haikuImage as AnyObject, forKey: imageURL as AnyObject)
                                
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
