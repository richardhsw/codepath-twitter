//
//  LoginViewController.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/4.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Init Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    // MARK: - Action Functions
    @IBAction func onLoginClicked(_ sender: Any) {
        let loginURL = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: loginURL, success: {
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            
        }, failure: {(Error) in
            print("Login Failure")
        })
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

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
