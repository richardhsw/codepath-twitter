//
//  TwitterURL.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/6.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

enum SegueIdentifiers: String {
    case loginSuccess, unwindToLogin
}

enum UserDefaultsKeys: String {
    case isLoggedIn
}

enum TwitterApiURL: String {
    case LoginURL = "https://api.twitter.com/oauth/request_token"
    case HomeFeedURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    case UpdateURL = "https://api.twitter.com/1.1/statuses/update.json"
    case FavoriteCreateURL = "https://api.twitter.com/1.1/favorites/create.json"
    case FavoriteDestroyURL = "https://api.twitter.com/1.1/favorites/destroy.json"
    case RetweetURL = "https://api.twitter.com/1.1/statuses/retweet/"
    case UnretweetURL = "https://api.twitter.com/1.1/statuses/unretweet/"
    case ProfileURL = "https://api.twitter.com/1.1/account/verify_credentials.json"
}

enum Cells: String {
    case TweetCell
}

enum TextViewStrings: String {
    case createTweet = "What's happening?"
}

enum FormatStrings: String {
    case dateFormat = "E MMM dd HH:mm:ss Z yyyy"
}

enum ImageNames: String {
    case favIcon = "favor-icon"
    case favIconHighlighted = "favor-icon-red"
    case retweetIcon = "retweet-icon"
    case retweetIconHighlighted = "retweet-icon-green"
}
