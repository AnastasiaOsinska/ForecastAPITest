//
//  AppDelegate.swift
//  ForecastAPiTest
//
//  Created by Anastasiya Osinskaya on 9/14/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         window = UIWindow(frame: UIScreen.main.bounds)
        let listOfCitiesViewController = ListOfCitiesViewController()
        let navigationController = UINavigationController(rootViewController: listOfCitiesViewController)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navigationController
        return true
    }
}

