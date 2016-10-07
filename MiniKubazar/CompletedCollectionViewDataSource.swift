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
    
    var firstLineCache = NSCache<AnyObject, AnyObject>()
    
    var secondLineCache = NSCache<AnyObject, AnyObject>()
    
    var thirdLineCache = NSCache<AnyObject, AnyObject>()
    
    var imageDownloadingQueue = OperationQueue()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return completedHaikus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "completedCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CompletedHaikusCollectionViewCell
        
        let completedHaiku = completedHaikus[(indexPath as NSIndexPath).row]
        
        let imageURL = completedHaiku.imageURLString
        
        let firstLine = completedHaiku.firstLineString
        
        let secondLine = completedHaiku.secondLineString
        
        let thirdLine = completedHaiku.thirdLineString
        
         let cachedImage = imageCache.object(forKey: imageURL as AnyObject)

        let cachedFirstLine = firstLineCache.object(forKey: imageURL as AnyObject)
        
        let cachedSecondLine = secondLineCache.object(forKey: imageURL as AnyObject)
        
        let cachedThirdLine = thirdLineCache.object(forKey: imageURL as AnyObject)
        
        if ((cachedImage) != nil) {
            if let newCachedImage = cachedImage as? UIImage {
            cell.updateWithImage(newCachedImage)
            }
        } else {
        
        self.imageDownloadingQueue.addOperation({
            let haikuImageRef = FIRStorage.storage().reference(forURL: imageURL!)
            haikuImageRef.data(withMaxSize: 1 * 3000 * 3000) { (data, error) in
                if (error != nil) {
                    print(error)
                    print("something wrong with completed haiku image from storage. check completed collection view data source code")
                } else {
                    let haikuImage = UIImage(data: data!)
       
                    cell.updateWithImage(haikuImage)

                    cell.firstHaikuLine.text = firstLine
                    
                    if haikuImage != nil {
                        self.imageCache.setObject(haikuImage as AnyObject, forKey: imageURL as AnyObject)
                    }
                }
            }})
        }
        
        if ((cachedFirstLine) != nil) {
            if let newCachedFirstLine = cachedFirstLine as? String {
            cell.firstHaikuLine.text = newCachedFirstLine
            }
        } else {
            cell.firstHaikuLine.text = firstLine
        }

        if ((cachedSecondLine) != nil) {
            if let newCachedSecondLine = cachedSecondLine as? String {
                cell.secondHaikuLineString = newCachedSecondLine
            }
        } else {
            cell.secondHaikuLineString = secondLine
        }
        
        if ((cachedThirdLine) != nil) {
            if let newCachedThirdLine = cachedThirdLine as? String {
                cell.thirdHaikuLineString = newCachedThirdLine
            }
        } else {
            cell.thirdHaikuLineString = thirdLine
        }
        
        
        return cell
    }

}
