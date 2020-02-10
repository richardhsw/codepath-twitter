//
//  TweetViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/9.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    // MARK: Variables
    @IBOutlet weak var tweetTextView: UITextView!

    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.becomeFirstResponder()
    }

    
    // MARK: Action Functions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loadTweets"), object: nil)
                })
            }, failure: { (Error) in
                print("Error posting tweet: \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            // TODO: improve by using an alert controller
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
