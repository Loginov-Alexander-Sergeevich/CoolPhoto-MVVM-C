//
//  AppDelegate.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navNC = UINavigationController()
        self.appCoordinator = AppCoordinator(navigationController: navNC)
        self.appCoordinator?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navNC
        window!.makeKeyAndVisible()

        return true
    }



}

