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
    
    var imageCache = NSCache()
    
    var imageDownloadingQueue = NSOperationQueue()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return completedHaikus.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "completedCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CompletedHaikusCollectionViewCell
        
        let completedHaiku = completedHaikus[indexPath.row]
        
        let imageURL = completedHaiku.imageURLString
        
        let cachedImage = imageCache.objectForKey(imageURL) as? UIImage
        
        if ((cachedImage) != nil) {
            cell.updateWithImage(cachedImage)
        } else {
        
        self.imageDownloadingQueue.addOperationWithBlock({
            let haikuImageRef = FIRStorage.storage().referenceForURL(imageURL)
            haikuImageRef.dataWithMaxSize(1 * 3000 * 3000) { (data, error) in
                if (error != nil) {
                    print(error)
                    print("something wrong with completed haiku image from storage. check completed collection view data source code")
                } else {
                    let haikuImage = UIImage(data: data!)
                    //                cell.imageView.image = haikuImage
                    cell.updateWithImage(haikuImage)
                    cell.firstHaikuLine.text = completedHaiku.firstLineString
                    
                    if haikuImage != nil {
                        self.imageCache.setObject(haikuImage!, forKey: imageURL)
                    }
                    
                    
                }
            }})
            
        
        }

        
        
//        cell.updateWithImage(completedHaiku.image)
        
        
        return cell
    }

}
