//
//  AppDelegate.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseAppCheck
import GoogleMaps
import GooglePlaces
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let providerFactory = TataweiAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        
        GMSServices.provideAPIKey("AIzaSyADEz8PXDl2MCv4hAy8tnDtDxRX-z6PJMk")
        GMSPlacesClient.provideAPIKey("AIzaSyADEz8PXDl2MCv4hAy8tnDtDxRX-z6PJMk")
        configureRealm()
        FirebaseApp.configure()
        IQKeyboardManager.shared.isEnabled = true
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 3, // Increment the schema version
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Perform migration logic if needed
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
            print("Realm initialized with schema version \(config.schemaVersion)")
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

