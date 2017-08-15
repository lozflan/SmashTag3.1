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
        static let sectionKey = "type"
    }
    
    /// fetches tweeters from coredata that have searchText in their tweets.
    private func fetchMentions() {
        
        if let context = container?.viewContext, searchText != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            let predicate = NSPredicate(format: "searchTerm = %@", searchText!)
            let sortDescriptors = [NSSortDescriptor(key: SortKey.type, ascending: true)]
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: SortKey.sectionKey,
                cacheName: nil)
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            fetchedResultsController?.delegate = self
        }
        
        
    }


    
    
    
    
    

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    
    private struct Storyboard {
        static let mentionCell = "Mention Cell"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionCell, for: indexPath)

        // Configure the cell...
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.keyword
            cell.detailTextLabel?.text = String(mention.count)
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
