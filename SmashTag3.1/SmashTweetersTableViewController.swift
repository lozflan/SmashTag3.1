//
//  SmashTweeterTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 4/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

 
    //model 
    
    var mention: String? { didSet { updateUI() }}
    
    var container: NSPersistentContainer? = AppDelegate.container { didSet { updateUI() }}
    
    var frc: NSFetchedResultsController<TwitterUser>? {
        didSet {
            frc?.delegate = self
        }
    }
    

    private func updateUI() {
        //ensure tableview is a frc delegate
        
        //create new freq and frc with the mention
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "handle", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        if let results = try? container?.viewContext.fetch(request) {
            
        }
        
        //Thursday, 4 May 2017 UP TO HERE 
//        let frc: NSFetchedResultsController<TwitterUser> = NSFetchedResultsController(fetchRequest: <#T##NSFetchRequest<NSFetchRequestResult>#>, managedObjectContext: <#T##NSManagedObjectContext#>, sectionNameKeyPath: <#T##String?#>, cacheName: <#T##String?#>)
        //execute the freq
        
        tableView.reloadData()
    }
    


    override func viewDidLoad() {
        
        
    }



}








