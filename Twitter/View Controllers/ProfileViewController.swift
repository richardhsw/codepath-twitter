//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/11.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2

        // Obtain user profile info
        getProfile()
    }
    
    func getProfile() {
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiURL.ProfileURL.rawValue, parameters: [:], success: { (profileJSON: NSDictionary) in
            
            // Extract info from JSON
            let username    = profileJSON["name"] as! String
            let screenname  = profileJSON["screen_name"] as! String
            let description = profileJSON["description"] as! String
            
            let followers = profileJSON["followers_count"] as! Int
            let following = profileJSON["friends_count"] as! Int
            
            var profileImg = profileJSON["profile_image_url_https"] as! String
            profileImg = profileImg.replacingOccurrences(of: "normal", with: "bigger")
            let profileImgURL = URL(string: profileImg)
            
            let bannerImg = profileJSON["profile_banner_url"] as? String
            var bannerImgURL : URL?
            
            if (bannerImg != nil) {
                let mobileBannerImg = bannerImg! + "/mobile_retina"
                bannerImgURL = URL(string: mobileBannerImg)
            }
            
            let profile = Profile(username: username, screenname: screenname, description: description, profileImageURL: profileImgURL!, bannerImageURL: bannerImgURL, followingCount: following, followerCount: followers)
            
            self.populateView(with: profile)
            
        }, failure: { (Error) in
            print("ERROR - Could not retrieve user profile:\n\(Error)")
        })
    }
    
    func populateView(with profile: Profile) {
        usernameLabel.text = profile.username
        screennameLabel.text = "@\(profile.screenname)"
        descriptionLabel.text = profile.description
        
        followingCountLabel.text = String(profile.followingCount)
        followersCountLabel.text = String(profile.followerCount)
        
        let profileData = try? Data(contentsOf: profile.profileImageURL)
        if let profileImgData = profileData {
            profileImageView.image = UIImage(data: profileImgData)
        }
        
        if (profile.bannerImageURL != nil) {
            let bannerData = try? Data(contentsOf: profile.bannerImageURL!)
            if let bannerImgData = bannerData {
                bannerImageView.image = UIImage(data: bannerImgData)
            }
        }
    }
}
