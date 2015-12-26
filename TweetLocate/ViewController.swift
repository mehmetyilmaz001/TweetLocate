//
//  ViewController.swift
//  TweetLocate
//
//  Created by Mehmet Yilmaz on 26/12/15.
//  Copyright © 2015 Ninjakod. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var kmSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationViewController : TweetListTableViewController
        destinationViewController = segue.destinationViewController as! TweetListTableViewController //
        
        
        
        if self.kmSelector.selectedSegmentIndex == 0 {
            destinationViewController.selectedKm = 1
            
        }else  if self.kmSelector.selectedSegmentIndex == 1 {
            destinationViewController.selectedKm = 5
            
        }else {
            destinationViewController.selectedKm = 10
            
        }
    }


}

