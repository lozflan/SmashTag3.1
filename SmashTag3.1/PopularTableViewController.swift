//
//  PopularityTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 8/8/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import CoreData



class PopularTableViewController: FetchedResultsTableViewController {
    
    // MARK: - Overview
    // TVC listing the most popular user and hashtag mentions in all tweets fetched (and stored in coredata) for a particular searchTerm
    
    // MARK: - Model 
    // need the searchText, the container. 
    // use the searchText to search text of all tweets stored in coredata
    
    var searchText: String? { didSet { updateUI() }}
    var container = AppDelegate.container { didSet { updateUI() }}
    
    // required var for superclass FetchedResultsTableViewController to work
    var fetchedResultsController: NSFetchedResultsController<Mention>?
    
    
    
    private func updateUI() {
        fetchMentions()
        
    }
    
    private struct SortKey {
        static let type = "type"
        static let keyword = "keyword"
        static let count = "count"
    }
    
    /// fetches tweeters from coredata that have searchText in their tweets.
    private func fetchMentions() {
        if let context = container?.viewContext, searchText != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            let predicate = NSPredicate(format: "searchTerm = %@ AND count > 1", searchText!)
            let sd1 = NSSortDescriptor(key: SortKey.type, ascending: true)
            let sd2 = NSSortDescriptor(key: SortKey.count, ascending: false)
            let sd3 = NSSortDescriptor(key: SortKey.keyword, ascending: true)
            let sortDescriptors = [sd1,sd2, sd3]
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: SortKey.type,
                cacheName: nil)
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            fetchedResultsController?.delegate = self
        }
    }


    // MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source
    
    private struct Storyboard {
        static let mentionCell = "Mention Cell"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionCell, for: indexPath)

        // Configure the cell...
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.keyword
            cell.detailTextLabel?.text = "mention count = " + String(mention.count)
        }
        return cell
    }
    

}
