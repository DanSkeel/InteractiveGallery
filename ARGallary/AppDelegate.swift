//
//  AppDelegate.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    let viewControllersProvider = ViewControllersProvider()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = self.window
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func makeRootViewController() -> UIViewController {
        let viewController = viewControllersProvider.viewControllerPresentingAlbums()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}

