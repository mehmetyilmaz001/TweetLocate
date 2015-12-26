//
//  TweetListTableViewController.swift
//  TweetLocate
//
//  Created by Mehmet Yilmaz on 26/12/15.
//  Copyright © 2015 Ninjakod. All rights reserved.
//

import UIKit

class TweetListTableViewController: UITableViewController {
    
    var selectedKm : Int! // ! = not null
    var allTweets = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        config.HTTPAdditionalHeaders = ["Content-Type":"application/x-www-form-urlencoded;charset=UTF-8",
            "User-Agent":"26_Dec_2015_Workshop_App",
            "Accept-Encoding":"gzip",
            "Authorization":"Basic SDFLZ0JMVUx1RDRFVTY3NjN5YlZVaWY3TTpMdUZXa1g2bUdzQUE4RjhZeTlPS3djb2Z4U01Da1NOUW5oaTJqMGhOMEwzZlBGUFJucw=="]
        
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "grant_type=client_credentials".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: config)
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let token = dict.valueForKey("access_token") as! String
                self.callTwitterWithToken(token)
            }
            catch{}
        }
        
        dataTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //data group
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.allTweets.count
    }
    
   
    func callTwitterWithToken(token:String) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["User-Agent":"26_Dec_2015_Workshop_App",
            "Accept-Encoding":"gzip",
            "Authorization":"Bearer \(token)"]
        
        let urlToCall = "https://api.twitter.com/1.1/search/tweets.json?q=&geocode=40.966807,29.068251,\(selectedKm)km&count=20"
        let request = NSMutableURLRequest(URL: NSURL(string: urlToCall)!)
        let session = NSURLSession(configuration: config)
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                self.allTweets = dict.valueForKey("statuses") as! [NSDictionary]
                self.performSelectorOnMainThread("updateUI", withObject: nil, waitUntilDone: false)
            }
            catch{}
        }
        dataTask.resume()
        
    }
    
    func updateUI(){
        self.tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath)

        let tweet = self.allTweets[indexPath.row]
        
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        userNameLabel.text = tweet["user"]!["screen_name"] as? String
        
        let tweetLabel = cell.viewWithTag(2) as! UILabel
        tweetLabel.text = tweet["text"] as? String
        
        let imageView = cell.viewWithTag(3) as! UIImageView
        let imageUrl = tweet["user"]!["profile_image_url"] as? String
        let image = NSURL(string : imageUrl!)
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(image!) { (returnedImageData:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if returnedImageData != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    imageView.image = UIImage(data: returnedImageData!)
                    
                    
                    
                })
                
            }
            
        }
        
        task.resume()

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
