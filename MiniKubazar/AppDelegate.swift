//
//  AppDelegate.swift
//  MiniKubazar
//
//  Created by Alyson Vivattanapa on 9/9/16.
//  Copyright © 2016 Alyson Vivattanapa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import HockeySDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        FIRApp.configure()
        BITHockeyManager.shared().configure(withIdentifier: "aff36663a8984d5c8d947b5bd884e3c6")
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()

        let navBarImage = UIImage(named: "kubazarNavBar")
        UINavigationBar.appearance().setBackgroundImage(navBarImage, for:.default)
        
        tabBarController = UITabBarController()
        let firstTab = BazarViewController(nibName: "BazarViewController", bundle: nil)
        let secondTab = StartViewController(nibName: "StartViewController", bundle: nil)
        let thirdTab = FriendsViewController(nibName: "FriendsViewController", bundle: nil)
        let fourthTab = InfoViewController(nibName: "InfoViewController", bundle: nil)
        let controllers = [firstTab, secondTab, thirdTab, fourthTab]
        tabBarController?.viewControllers = controllers
        
        UITabBar.appearance().tintColor = UIColor(red: 12.0/255, green: 87.0/255, blue: 110.0/255, alpha: 1)
        
        firstTab.tabBarItem = UITabBarItem(title: "Bazar", image: UIImage(named: "bazarA"), selectedImage: UIImage(named: "bazarB"))
        
        secondTab.tabBarItem = UITabBarItem(title: "Start", image: UIImage(named: "startA"), selectedImage: UIImage(named: "startB"))
        
        thirdTab.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friendsA"), selectedImage: UIImage(named: "friendsB"))
        
         fourthTab.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "infoA"), selectedImage: UIImage(named: "infoB"))
        
        if let user = FIRAuth.auth()?.currentUser {
            print("App Delegate says user is signed in with uid:", user.uid)
            self.window?.rootViewController = self.tabBarController
            self.tabBarController?.selectedIndex = 0
            
        } else {
            print("App Delegate says no user is signed in.")
            let welcomeVC = WelcomeViewController()
            self.window?.rootViewController = welcomeVC
        }

        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

