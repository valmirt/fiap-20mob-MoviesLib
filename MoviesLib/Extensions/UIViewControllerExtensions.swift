//
//  UIViewControllerExtensions.swift
//  MoviesLib
//
//  Created by Valmir Junior on 26/09/20.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
}
