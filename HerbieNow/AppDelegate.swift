//
//  AppDelegate.swift
//  HerbieNow
//
//  Created by Benno Kress on 07.11.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import IQKeyboardManagerSwift
import OAuthSwift
import OAuthSwiftAlamofire
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var appData = AppData.shared
    var currentInterpreter : LocationUpdateDelegate?

    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        m.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        m.allowsBackgroundLocationUpdates = true
        return m
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // MARK: - IQKeyboardManager
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = false
        keyboardManager.keyboardDistanceFromTextField = 16.0

        // MARK: - Alamofire Network Indicator
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        // MARK: - Hide Status Bar
        application.isStatusBarHidden = true

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        OAuthSwift.handle(url: url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HerbieNow")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Location Manager

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let locationObject = Location(latitude: latitude, longitude: longitude)

        guard let interpreter = currentInterpreter else { return }

        interpreter.locationUpdated(locationObject)

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Debug.print(.error(source: .location(Source()), message: "Location Manager could not retrieve location data."))
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if case CLAuthorizationStatus.authorizedAlways = status {
            manager.startUpdatingLocation()
        }

    }

    func registerCurrentInterpreterForLocationUpdates(_ interpreter: LocationUpdateDelegate) {
        self.currentInterpreter = interpreter
    }

}
