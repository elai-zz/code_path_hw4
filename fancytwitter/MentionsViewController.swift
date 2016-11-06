//
//  MentionsViewController.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/5/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sadView: UIView!
    @IBOutlet weak var mentionsTable: UITableView!
    var mentions : [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sadView.isHidden = true

        // Do any additional setup after loading the view.
        mentionsTable.dataSource = self
        mentionsTable.delegate = self
        mentionsTable.estimatedRowHeight = 100
        mentionsTable.rowHeight = UITableViewAutomaticDimension
        
        setUpUserMentions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.mentions != nil) {
            return self.mentions!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mentionsTable.dequeueReusableCell(withIdentifier: "mentionsCell", for: indexPath) as! MentionsCell
        cell.profileImageView.setImageWith((mentions?[indexPath.row].imageURL)!)
        cell.tweetLabel.text = mentions?[indexPath.row].text as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mentionsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func setUpUserMentions() {
        TwitterClient.sharedInstance?.getUserMentions(success: { (returnedTweets) in
            if returnedTweets.count == 0 {
                self.sadView.isHidden = false
            } else {
                self.mentions = returnedTweets
                self.mentionsTable.reloadData()
            }
        }, failure: { (failure) in
            NSLog(failure.localizedDescription)
        })
    }
    
    @IBAction func onTapGesture(_ sender: Any) {
        self.navigationController?.performSegue(withIdentifier: "mentionsToUser", sender: sender)
    }

}
