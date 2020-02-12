//
//  Profile.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/11.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

struct Profile {
    let username : String
    let screenname : String
    let description : String
    let profileImageURL : URL
    let bannerImageURL : URL?
    let followingCount : Int
    let followerCount : Int
}
