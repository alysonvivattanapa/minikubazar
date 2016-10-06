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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let identifier = "friendsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FriendsTableViewCell
        
        let friend = friendArray[(indexPath as NSIndexPath).row]

        cell.friendsUsername.text = friend.email
        
        return cell
    }

}
