//
//  SignInViewController.swift
//  ios-id
//
//  Created by Nikhil Prabhakar on 7/27/17.
//  Copyright © 2017 Impulse Labs. All rights reserved.
//

import UIKit



class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var lblSignedOut: UILabel!
    @IBOutlet weak var vbtnGoogleSignIn: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        lblSignedOut.text = "Please Log in"
    }

}
