//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/4.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    // MARK: - Variables
    let myRefreshControl = UIRefreshControl()
    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    let dateFormatterGet = DateFormatter()

    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format date time
        dateFormatterGet.dateFormat = FormatStrings.dateFormat.rawValue
        
        // Get tweets
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        // Add observer to tweet
        NotificationCenter.default.addObserver(self, selector: #selector((loadTweets)), name: NSNotification.Name(rawValue: "loadTweets"), object: nil)
        
        // Set cell heights
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - TableView Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TweetCell.rawValue, for: indexPath) as! TweetTableViewCell
        
        let tweetJSON = tweetArray[indexPath.row]
        let tweet = ParseTweet(tweetJSON: tweetJSON)
        
        PopulateCell(forCell: cell, with: tweet)
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == tweetArray.count) {
            // TODO: fix infinite scroll here
            // loadMoreTweets()
        }
    }
    
    
    // MARK: - Twitter Functions
    @objc func loadTweets() {
        numOfTweets = 20
        let params = ["counts": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: TwitterApiURL.HomeFeedURL.rawValue, parameters: params as [String : Any], success: { (tweetsJSON: [NSDictionary]) in
            
            self.populateTwitterArray(tweets: tweetsJSON)
            
        }, failure: { (Error) in
            print("ERROR: Could not retrieve initial tweets.")
            print(Error)
        })
        
        self.myRefreshControl.endRefreshing()
    }
    
    func populateTwitterArray(tweets: [NSDictionary]){
        self.tweetArray.removeAll()
        
        for tweet in tweets {
            self.tweetArray.append(tweet)
        }
        
        self.tableView.reloadData()
    }
    
    func loadMoreTweets() {
        numOfTweets = tweetArray.count + 20
        let params = ["counts": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: TwitterApiURL.HomeFeedURL.rawValue, parameters: params as [String : Any], success: { (tweetsJSON: [NSDictionary]) in
            
            // If there are no new data obtained from API call,
            // stop infinite scrolling to prevent loop.
            self.populateTwitterArray(tweets: tweetsJSON)
            
        }, failure: { (Error) in
            print("ERROR: Could not retrieve more tweets.")
        })
    }

    // MARK: - Action Functions
    @IBAction func onLogoutClicked(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        self.performSegue(withIdentifier: SegueIdentifiers.unwindToLogin.rawValue, sender: self)
    }
    
    
    // MARK: - Helper Functions
    func ParseTweet(tweetJSON: NSDictionary) -> Tweet {
        
        // Get text info
        let id   = tweetJSON["id"] as! Int
        let user = tweetJSON["user"] as! NSDictionary
        let text = tweetJSON["text"] as! String
        let name = user["name"] as! String
        let screen = "@" + (user["screen_name"] as! String)
        
        // Get picture info
        let profile = user["profile_image_url_https"] as! String
        let profileURL = URL(string: profile)!
        
        // Get time info
        let timeString = tweetJSON["created_at"] as! String
        let elapsed    = GetDate(apiString: timeString)
        
        // Get favorite info
        let favorited = tweetJSON["favorited"] as! Bool
        let favCount  = tweetJSON["favorite_count"] as! Int
        
        // Get retweet info
        let retweeted    = tweetJSON["retweeted"] as! Bool
        let retweetCount = tweetJSON["retweet_count"] as! Int
        
        let tweet = Tweet(id: id, username: name, screenname: screen, timeAgo: elapsed, profilePicURL: profileURL, text: text, favorited: favorited, favCount: favCount, retweeted: retweeted, retweetCount: retweetCount)
        
        return tweet
    }
    
    func PopulateCell(forCell cell: TweetTableViewCell, with tweet: Tweet) {
        // Populate UI with tweet info
        // Fill in text information
        cell.usernameLabel.text   = tweet.username
        cell.screennameLabel.text = tweet.screenname
        cell.timeLabel.text       = " · " + tweet.timeAgo
        
        cell.tweetContentLabel.text = tweet.text
        
        // Fill in picture information
        let data = try? Data(contentsOf: tweet.profilePicURL)
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        // Fill in button information
        cell.tweetID = tweet.id
        
        cell.setFavorite(tweet.favorited)
        cell.favCountLabel.text = String(tweet.favCount)
        
        cell.setRetweeted(tweet.retweeted)
        cell.retweetCountLabel.text = String(tweet.retweetCount)
    }
    
    func GetDate(apiString: String) -> String {
        let date = dateFormatterGet.date(from: apiString)
        guard let elapsed = date?.getElapsedInterval() else { return "1m" }
        
        return elapsed
    }
}
