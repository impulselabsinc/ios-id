//
//  MainViewController.swift
//  ios-id
//
//  Created by Nikhil Prabhakar on 7/28/17.
//  Copyright © 2017 Impulse Labs. All rights reserved.
//

import UIKit

protocol TypeName: AnyObject {
    static var typeName: String { get }
}

extension TypeName {
    static var typeName: String {
        let type = String(describing: self)
        return type
    }
}


class MainViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var lblLoggedInStatus: UILabel!
    let btnSignOut: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    @IBOutlet weak var nvLoggedInNavItem: UINavigationItem!
    var isSignedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
        self.setupNavigationBar()
        
        // Wrapping this to make this controller testable
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            self.isSignedIn = true
            GIDSignIn.sharedInstance().scopes = [
                "https://www.googleapis.com/auth/userinfo.email",
                "https://www.googleapis.com/auth/userinfo.profile",
                "https://www.googleapis.com/auth/plus.me"]
            GIDSignIn.sharedInstance().signInSilently()
        }
        toggleUIAuthState()
    }

    
    func setupNavigationBar() {
        nvLoggedInNavItem.title = "Impulse Labs Demo"
        nvLoggedInNavItem.prompt = "Honey Badger Don't Care!"
    }
    
    func toggleUIAuthState(){
        if self.isSignedIn {
            self.view.backgroundColor = UIColor(red: 150/255, green: 200/255, blue: 150/255, alpha: 1.0)
            nvLoggedInNavItem.rightBarButtonItem = btnSignOut
            nvLoggedInNavItem.rightBarButtonItem?.target = self
            nvLoggedInNavItem.rightBarButtonItem?.action = #selector(self.signOut(_:))
            nvLoggedInNavItem.rightBarButtonItem?.title = "Sign-out"
            nvLoggedInNavItem.rightBarButtonItem?.isEnabled = true
            if let profileName = UserDefaults.standard.string(forKey: "profileName"){
                lblLoggedInStatus.text = "You are logged in as \(profileName)"
            }
        } else{
            self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            nvLoggedInNavItem.rightBarButtonItem?.isEnabled = false
            nvLoggedInNavItem.rightBarButtonItem?.title = ""
            lblLoggedInStatus.text = "You are not logged in"
            presentSignInView()
        }
    }

    
    func signOut(_ sender:AnyObject) {
        UserDefaults.standard.removeObject(forKey: "profileName")
        GIDSignIn.sharedInstance().signOut()
        self.isSignedIn = false
        toggleUIAuthState()
    }
    
    func presentSignInView(){
        let signInStoryboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let signInVC = signInStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(signInVC, animated: true, completion: nil)
    }

}

extension MainViewController:GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google Sign-in Error: \(error.localizedDescription)")
        } else {
            if let profileName = user.profile.name{
                print("DEBUG: \(profileName)")
                UserDefaults.standard.set(profileName, forKey: "profileName")
                self.dismiss(animated: true, completion: nil)
                
                self.isSignedIn = true
                toggleUIAuthState()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().disconnect()
        UserDefaults.standard.removeObject(forKey: "profileName")
        self.isSignedIn = false
        toggleUIAuthState()
    }
    
}

