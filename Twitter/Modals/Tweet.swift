//
//  Tweet.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/9.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

struct Tweet {
    let id : Int
    let username : String
    let screenname : String
    let timeAgo : String
    let profilePicURL : URL
    let text : String
    let favorited : Bool
    let retweeted : Bool
}
