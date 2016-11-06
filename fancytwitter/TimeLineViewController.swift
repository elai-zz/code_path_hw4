//
//  TimeLineViewController.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/5/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timelineTableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.homeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.timelineTableView.reloadData()
        }, failure: { (error) in
            NSLog(error.localizedDescription)
        })
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.estimatedRowHeight = 100
        timelineTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets != nil) ? tweets.count : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimelineCell
        if (tweets) != nil {
            let tweet = self.tweets[indexPath.row]
            cell.tweetLabel.text = tweet.text as String?
            cell.handleLabel.text = "@\(tweet.screenName as! String)"
            cell.profileImageView.setImageWith(tweet.imageURL!)
            cell.timeStampLabel.text = getTimeDifference(createdDate: tweet.timestamp!)
        }
        return cell
    }
    
    func getTimeDifference(createdDate: NSDate) -> String {
        let datetimeNow = NSDate()
        let timeInterval = datetimeNow.timeIntervalSince(createdDate as Date) // in seconds
        if (timeInterval < 60) {
            return "\(Int(ceil(timeInterval)))s"
        } else if (timeInterval < 3600) {
            return "\(Int(ceil(timeInterval/60)))m"
        } else if (timeInterval < 86400) {
            return "\(Int(ceil(timeInterval/3600)))h"
        } else {
            return "\(Int(ceil(timeInterval/86400)))d"
        }
    }


}
