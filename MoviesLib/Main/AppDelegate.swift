//
//  AppDelegate.swift
//  MoviesLib
//
//  Created by Valmir Junior on 22/09/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor(named: "Main")
        
        return true
    }
    
    //MARK: - CoreData Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesLib")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                //Handler error
                print(error)
            }
        }
        
        return container
    }()
}

