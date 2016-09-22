//
//  FriendsTableViewDataSource.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/21/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit

class FriendsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var uidStringArray = [String]()
    
    var friendArray = [User]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let identifier = "friendsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! FriendsTableViewCell
        
        let friend = friendArray[indexPath.row]
        cell.friendsUsername.text = friend.username
        
        return cell
    }

}
