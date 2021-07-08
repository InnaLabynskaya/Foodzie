//
//  AppDelegate.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import UIKit
import CoreData
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let assembler = AppAssembler()
    var router: Router!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupGoogleMaps()
        router = Router(window: UIWindow(frame: UIScreen.main.bounds),
                        resolver: assembler.resolver)
        router.navigateToRoot()
        return true
    }

    private func setupGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyDdTzCmUU2-0i6D0Kl3iwi3s4VjyhF0Jn0")
    }
    
}

