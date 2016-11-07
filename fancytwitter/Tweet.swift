//
//  Tweet.swift
//  Twitter
//
//  Created by Estella Lai on 10/29/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var screenName: NSString?
    var imageURL: URL?
    var id: NSString?
    
    init(dictionary : NSDictionary) {
        screenName = (dictionary["user"] as! NSDictionary)["screen_name"] as? NSString
        let imageURLString = (dictionary["user"] as! NSDictionary)["profile_image_url_https"] as? String
        imageURL = URL(string: imageURLString!)
        text = dictionary["text"] as? NSString
        id = dictionary["id_str"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y" // common
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
