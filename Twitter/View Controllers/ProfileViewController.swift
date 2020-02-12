//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/11.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Obtain user profile info
        getProfile()
    }
    
    func getProfile() {
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiURL.ProfileURL.rawValue, parameters: [:], success: { (profileJSON: NSDictionary) in
            
            // Extract info from JSON
            let username   = profileJSON["name"] as! String
            let screenname = profileJSON["screen_name"] as! String
            
            let followers = profileJSON["followers_count"] as! Int
            let following = profileJSON["friends_count"] as! Int
            
            var profileImg = profileJSON["profile_image_url_https"] as! String
            profileImg = profileImg.replacingOccurrences(of: "normal", with: "bigger")
            let profileImgURL = URL(string: profileImg)
            
            let profile = Profile(username: username, screenname: screenname, profileImageURL: profileImgURL!, followingCount: following, followerCount: followers)
            
            self.populateView(with: profile)
            
        }, failure: { (Error) in
            print("ERROR - Could not retrieve user profile:\n\(Error)")
        })
    }
    
    func populateView(with profile: Profile) {
        usernameLabel.text = profile.username
        screennameLabel.text = "@" + profile.screenname
        followingCountLabel.text = String(profile.followingCount)
        followersCountLabel.text = String(profile.followerCount)
        
        let data = try? Data(contentsOf: profile.profileImageURL)
        if let imageData = data {
            profileImageView.image = UIImage(data: imageData)
        }
    }
}
