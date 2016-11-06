//
//  UserViewController.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/5/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    var currentUser: String?
    var user: User?
    var tweets: [Tweet]?
    
    @IBOutlet weak var userTimelineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSelfView()
        setUpUserTimeline()
        
        userTimelineTable.delegate = self
        userTimelineTable.dataSource = self
        userTimelineTable.estimatedRowHeight = 100
        userTimelineTable.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpSelfView() {
        if currentUser == nil {
            TwitterClient.sharedInstance?.currentAccount(success: { (user) in
                self.user = user
                self.userLabel.text = user.name as String?
                self.screenNameLabel.text = "@\(user.screenName as! String)"
                self.tweetCount.text = "\(user.numTweet!)"
                self.followerCount.text = "\(user.numFollowers!)"
                self.followingCount.text = "\(user.numFollowing!)"
                self.profileImageView.setImageWith(user.profileUrl as! URL)
                self.backgroundImageView.setImageWith(user.backgroundUrl as! URL)
                
            }, failure: { (failure) in
                // failed to retrieve current user
                NSLog(failure.localizedDescription)
            })

        } else {
            TwitterClient.sharedInstance?.getOtherUser(userId: self.currentUser, success: { (user) in
                self.user = user
                self.userLabel.text = user.name as String?
                self.screenNameLabel.text = "@\(user.screenName as! String)"
                self.tweetCount.text = "\(user.numTweet!)"
                self.followerCount.text = "\(user.numFollowers!)"
                self.followingCount.text = "\(user.numFollowing!)"
                self.profileImageView.setImageWith(user.profileUrl as! URL)
                self.backgroundImageView.setImageWith(user.backgroundUrl as! URL)
                self.view.layoutIfNeeded()
            }, failure: { (error) in
                NSLog(error.localizedDescription)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tweets != nil) {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTimelineTable.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! UserTimelineCell
        let tweet = tweets![indexPath.row] as Tweet
        cell.profileImageView.setImageWith((tweet.imageURL)!)
        cell.tweetLabel.text = tweet.text as? String
        
        let dateLabelStirng = "\(tweet.timestamp!)"
        let dateLabelArray = dateLabelStirng.components(separatedBy: " ")
        cell.tweetDateLabel.text = "\(dateLabelArray[0]) \(dateLabelArray[1])"
        
        return cell
    }

    
    func setUpUserTimeline() {
        TwitterClient.sharedInstance?.getUserTimeline(userId: currentUser, success: { (returnedTweets) in
            self.tweets = returnedTweets
            self.userTimelineTable.reloadData()
        }, failure: { (failure) in
            NSLog(failure.localizedDescription)
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userTimelineTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func setUser(screenName : String) {
        self.navigationItem.title = "@\(screenName)"
        currentUser = screenName
    }
}
