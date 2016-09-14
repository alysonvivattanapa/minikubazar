//
//  CompletedCollectionViewDataSource.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/14/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class CompletedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var completedHaikus = [CompletedHaiku]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return completedHaikus.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "completedCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CompletedHaikusCollectionViewCell
        
        let completedHaiku = completedHaikus[indexPath.row]
        cell.updateWithImage(completedHaiku.image)
        
        return cell
    }

}
