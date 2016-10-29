//
//  SebastiaanSchoolAppDelegate.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit

import Fabric
import Crashlytics

@UIApplicationMain
class SebastiaanSchoolAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])


        // Apply UIAppearance
        self.window?.tintColor = SebastiaanStyle.sebastiaanBlueColor
        UINavigationBar.appearance().barTintColor = SebastiaanStyle.sebastiaanBlueColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        
        return true
    }
}
