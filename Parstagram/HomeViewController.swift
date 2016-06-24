//
//  HomeViewController.swift
//  Parstagram
//
//  Created by Bonnie Nguyen on 6/20/16.
//  Copyright © 2016 Bonnie Nguyen. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var feedPosts:[PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getPosts()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
        self.navigationController?.setNavigationBarHidden(self.navigationController?.navigationBarHidden == false, animated: true)
    }
    
    @IBAction func uploadButton(sender: AnyObject) {
        self.performSegueWithIdentifier("uploadSegue", sender: self)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getPosts()
        self.tableView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func refreshControlGetPosts(refreshControl: UIRefreshControl) {
        getPosts()
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func getPosts() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.feedPosts = objects
                    self.tableView.reloadData()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return feedPosts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myParseCell", forIndexPath: indexPath) as! parseCell
        let postObject = self.feedPosts[indexPath.section]
        if let myString = postObject.valueForKey("caption") {
            cell.feedText.text = myString as? String
            cell.feedImage.file = postObject["media"] as? PFFile
            cell.feedImage.loadInBackground()
        }
        
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
