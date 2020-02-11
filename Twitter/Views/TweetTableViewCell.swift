//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/4.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var tweetID: Int = -1
    var favorited: Bool = false
    var retweeted: Bool = false
    
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    // MARK: - Action Functions
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("ERROR - Failure to favorite tweet:\n\(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("ERROR - Failure to unfavorite tweet:\n\(Error)")
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        let toBeRetweeted = !retweeted
        if (toBeRetweeted) {
            TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
                self.setRetweeted(true)
            }, failure: { (Error) in
                print("ERROR - Failure to retweet:\n\(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.unretweet(tweetID: tweetID, success: {
                self.setRetweeted(false)
            }, failure: { (Error) in
                print("ERROR - Failure to unretweet:\n\(Error)")
            })
        }
    }
    
    
    // MARK: - Public functions
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: ImageNames.favIconHighlighted.rawValue), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: ImageNames.favIcon.rawValue), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: ImageNames.retweetIconHighlighted.rawValue), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else {
            retweetButton.setImage(UIImage(named: ImageNames.retweetIcon.rawValue), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
}
