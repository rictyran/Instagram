//
//  UserTableViewController.swift
//  Instagram
//
//  Created by Richard Tyran on 4/28/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    var users = [""]
    var following = [Bool]()
    
    var refresher:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(PFUser.currentUser())

        updateUsers()
        
            refresher = UIRefreshControl()
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.addSubview(refresher)
        
        }
        
        func updateUsers() {
            
            var query = PFUser.query()
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                
                self.users.removeAll(keepCapacity: true)
                
                for object in objects {
                    
                    var user:PFUser = object as PFUser
                    
                    var isFollowing:Bool
                    
                    if user.username != PFUser.currentUser().username {
                        
                        self.users.append(user.username)
                        
                        isFollowing = false
                        
                        var query = PFQuery(className:"followers")
                        query.whereKey("follower", equalTo:PFUser.currentUser().username)
                        query.whereKey("following", equalTo:user.username)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                
                                if let objects = objects as? [PFObject] {
                                    for object in objects {
                                        
                                        isFollowing = true
                                        
                                    }
                                }
                                
                                self.following.append(isFollowing)
                                
                                self.tableView.reloadData()
                                
                            } else {
                                // Log details of the failure
                                println(error)
                            }
                        
                            self.refresher.endRefreshing()
                        
                        }
                        
                    }
                    
                }

            }
        
        }
        
        func refresh() {
        
            println("refreshed")
        
            updateUsers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        if following.count > indexPath.row {
        
        if following[indexPath.row] {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            }
        
        }
        
        cell.textLabel?.text = users[indexPath.row]
        
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo:cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                   
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                        
                            object.deleteInBackground()
                            
                        }
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            }

        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.saveInBackground()
            
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
