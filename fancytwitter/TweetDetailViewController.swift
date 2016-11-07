//
//  TweetDetailViewController.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/6/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextView!
    
    var currentTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tweet = currentTweet {
            tweetLabel.text = tweet.text as String?
            screenNameLabel.text = "@\(tweet.screenName as! String)"
            tweetCountLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favoritesCount)
            let dateLabelStirng = String(describing: tweet.timestamp!)
            let dateLabelArray = dateLabelStirng.components(separatedBy: " ")
            tweetDateLabel.text = "\(dateLabelArray[0]) \(dateLabelArray[1])"
            
            profileImageView.setImageWith(tweet.imageURL!)
            textField.text = "@\(tweet.screenName!)"
        }
        
        heartImageView.isUserInteractionEnabled = true
        retweetImageView.isUserInteractionEnabled = true
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(self.onFavoriteClick))
        heartImageView.addGestureRecognizer(favoriteTap)
        
        let retweetTap = UITapGestureRecognizer(target: self, action: #selector(self.onRetweetClick))
        retweetImageView.addGestureRecognizer(retweetTap)
        
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 3.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func onReplyButton(_ sender: Any) {
        let formattedString = textField.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        TwitterClient.sharedInstance?.reply(id: "\(currentTweet!.id as! String)", status: formattedString, success: {
            self.createAlert(title: "OK", message: "You've replied to this tweet.")
            self.textField.text = "@\(self.currentTweet!.screenName!)"
        }, failure: { (error) in
            self.createAlert(title: "Oops", message: error.localizedDescription)
        })
    }
    
    @IBAction func onRetweetClick(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(id: "\(currentTweet!.id as! String)", success: {
            self.createAlert(title: "OK", message: "You've retweeted this tweet.")
            self.tweetCountLabel.text = String((self.currentTweet?.retweetCount)! + 1)
        }, failure: { (error) in
            self.createAlert(title: "Oops", message: error.localizedDescription)
        })
    }
    
    @IBAction func onFavoriteClick(_ sender: AnyObject) {
        self.createAlert(title: "OK", message: "You've favorited this tweet.")
        TwitterClient.sharedInstance?.favoriteTweet(id: "\(currentTweet!.id as! String)", success: {
            self.createAlert(title: "OK", message: "You've favorited this tweet.")
            self.favoriteCountLabel.text = String((self.currentTweet?.favoritesCount)! + 1)
        }, failure: { (error) in
            self.createAlert(title: "Oops", message: error.localizedDescription)
        })
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
