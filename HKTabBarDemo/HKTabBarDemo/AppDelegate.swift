//
//  AppDelegate.swift
//  HKTabBarDemo
//
//  Created by PDA-iOS on 2019/2/28.
//  Copyright © 2019年 Heikki. All rights reserved.
//

import UIKit

let HK_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let HK_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let tabVc = HKTabBarViewController()
        window?.rootViewController = tabVc
        window?.makeKeyAndVisible()
        
        return true
    }
}
