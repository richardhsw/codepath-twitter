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
}

enum Cells: String {
    case TweetCell
}
