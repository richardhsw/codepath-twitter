//
//  TweetViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/9.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate{

    // MARK: - Variables
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    
    let characterLimit = 140

    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeTextView()
        
        getProfilePicture()
    }
    
    
    // MARK: - TextView Functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // placeholder text code obtained from https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = TextViewStrings.createTweet.rawValue
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = UIColor.black
                textView.text = text
        }
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newTextCount = updatedText.count

        // Update Character Count Label
        charCountLabel.text = String(characterLimit - newTextCount)

        // The new text should be allowed? True/False
        return newTextCount < characterLimit
    }
    
    func customizeTextView() {
        tweetTextView.delegate = self
        
        tweetTextView.layer.borderWidth = 1
        tweetTextView.layer.borderColor = UIColor.darkGray.cgColor
        tweetTextView.layer.cornerRadius = 6
        
        tweetTextView.text = TextViewStrings.createTweet.rawValue
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.becomeFirstResponder()
        tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
    }
    
    
    // MARK: - Private Functions
    func getProfilePicture() {
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiURL.ProfileURL.rawValue, parameters: [:], success: { (profileJSON: NSDictionary) in
            
            // Extract profile pic URL
            var profileImg = profileJSON["profile_image_url_https"] as! String
            profileImg = profileImg.replacingOccurrences(of: "normal", with: "bigger")
            let profileImgURL = URL(string: profileImg)
            
            // Display profile pic
            let data = try? Data(contentsOf: profileImgURL!)
            if let imageData = data {
                self.profileImgView.image = UIImage(data: imageData)
            }
            
        }, failure: { (Error) in
            print("ERROR - Could not retrieve user profile:\n\(Error)")
        })
    }
    
    // MARK: - Action Functions
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

}
