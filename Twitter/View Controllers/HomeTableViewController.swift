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

    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TweetCell.rawValue, for: indexPath) as! TweetTableViewCell
        
        // Extract info from JSON
        let tweetJSON = tweetArray[indexPath.row]
        
        let user = tweetJSON["user"] as! NSDictionary
        let text = tweetJSON["text"] as? String
        let name = user["name"] as? String
        
        let profile    = user["profile_image_url_https"] as? String
        let profileURL = URL(string: profile!)
        
        let tweet = Tweet(username: name!, profilePicURL: profileURL!, text: text!)
        
        // Populate UI with tweet info
        cell.usernameLabel.text = tweet.username
        
        let data = try? Data(contentsOf: tweet.profilePicURL)
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.tweetContentLabel.text = tweet.text
        
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
}
