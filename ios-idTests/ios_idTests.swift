//
//  ios_idTests.swift
//  ios-idTests
//
//  Created by Nikhil Prabhakar on 7/27/17.
//  Copyright © 2017 Impulse Labs. All rights reserved.
//

import XCTest
@testable import ios_id

class ios_idTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set("Honey Badger", forKey: "profileName")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: "profileName")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDoesPresentSignInView() {
        let vc = UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController
        XCTAssertNotNil(vc)
        XCTAssertTrue(vc is SignInViewController, "The app presents the sign in view when user is not authenticated")
    }
    
    func testMainViewItemsAreVisible(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.isSignedIn = true
        XCTAssertNotNil(mainViewController.view, "The mainViewController should have been instantiated")
        XCTAssertTrue((mainViewController.navigationItem.rightBarButtonItem?.isEnabled)!, "Sign-out button is enabled")
        XCTAssertEqual(mainViewController.lblLoggedInStatus.text, "You are logged in as Honey Badger")
    }
    
}
