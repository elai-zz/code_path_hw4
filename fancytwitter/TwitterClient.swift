//
//  TwitterClient.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/5/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "G4DqzfqGG2YYquTbDamCGDTeG", consumerSecret: "voiED1iAXdyt8uMAGys8l44dkZgG3esjnmr4nXKwaejDdzOdpL")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping  (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user) in
                self.loginSuccess?()
                User.currentUser = user
            }, failure: {(error) in
                self.loginFailure?(error as Error)
            })}, failure: { (error) in
                if let error = error {
                    self.loginFailure?(error)
                }
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(
            withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterdemo://oauth") as URL!, scope: nil,
            success: {(requestToken: BDBOAuth1Credential?) -> Void in
                let token = requestToken?.token
                let string = "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)"
                let url = NSURL(string: string)
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) -> Void in
            if let error = error {
                self.loginFailure?(error)
            }
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func tweet(status: String, success: @escaping() -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json?status=\(status)", parameters: nil, progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func favoriteTweet(id: String, success: @escaping() -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func retweet(id: String, success: @escaping() -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func getUserTimeline(userId: String?, success: @escaping([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        if (userId == nil) {
            get("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
                let tweetDictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
                success(tweets)
            }) { (task, error) in
                failure(error)
            }
        }
    }
    
    func getUserMentions(success: @escaping([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            success(tweets)
        }) { (task, error) in
            failure(error)
        }
    }
}
