//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/4.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
    }
    
    // MARK: - Twitter Functions
    func loadTweets() {
        let tweetsAPI = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["counts": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsAPI, parameters: params, success: { (tweetsJSON: [NSDictionary]) in
            
            self.populateTwitterArray(tweets: tweetsJSON)
            
        }, failure: { (Error) in
            print("ERROR: Could not retrieve tweets.")
        })
    }
    
    func populateTwitterArray(tweets: [NSDictionary]){
        self.tweetArray.removeAll()
        
        for tweet in tweets {
            self.tweetArray.append(tweet)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweetArray[indexPath.row]
        
        // Set tweet username
        let user  = tweet["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        
        // Set tweet user's profile pic
        let profileURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: profileURL!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        // Set tweet text
        cell.tweetContentLabel.text = tweet["text"] as? String
        
        return cell
    }

    // MARK: - Action Functions
    @IBAction func onLogoutClicked(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
}
