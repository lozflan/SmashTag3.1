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

class SmashTweetersTableViewController: FetchedResultsTableViewController {

 
    //model 
    
    var mention: String? { didSet { updateUI() }}
    
    var container: NSPersistentContainer? = AppDelegate.container { didSet { updateUI() }}
    
    var fetchedResultsController: NSFetchedResultsController<TwitterUser>?
    

    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            //create new freq and frc with the mention
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "handle", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            let predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [sortDescriptor]
            request.predicate = predicate
            
            //create a frc instance if the mention (or container) is updated
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            //perform the actual fetch
            try? fetchedResultsController?.performFetch()
            //set ourselves as the frc delegate
            self.fetchedResultsController?.delegate = self
            //get the tableview to call its required methods
            tableView.reloadData()
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for: indexPath)
        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.name
            let tweetCount = tweetCountWithMentionBy(twitterUser)
                
                
            cell.detailTextLabel?.text = "\(tweetCount) tweet" + "\((tweetCount) > 1 ? "s" : "")"
        }
        return cell
    }
    
    private func tweetCountWithMentionBy(_ twitterUser: TwitterUser) -> Int {
        //you have a twitterUser so use that MO's context
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        let predicate = NSPredicate(format: "text contains[c] %@ AND tweeter = %@", mention!, twitterUser)
        request.predicate = predicate

        let count = (try? twitterUser.managedObjectContext!.count(for: request)) ?? 0
        return count
        
//            
//            if let tweets = try? context.fetch(request) {
//                return tweets.count
//            } else {
//                return 0
//            }
    }
 



}








