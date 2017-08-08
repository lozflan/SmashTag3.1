// 
//  RecentSearchesTableViewController.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 6/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import UIKit

class RecentSearchesTableViewController: UITableViewController {
    
    
    // Tuesday, 6 June 2017
    // need to store in UDs and array should be fine
    
    // model needs either an array of searchTerms or a set. array better for ordering, set better for uniqueing.
    
    let defaults = UserDefaults.standard
    
    var recentSearches: [String]  {
        // you can access the model directly thru RecentSearches 
        return RecentSearches.searches
    }
    

    
    // Wednesday, 7 June 2017 
    // searchTerms now being saved in TweetTVC to userdefaults and retrieved here.
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentSearches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearch Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            RecentSearches.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //            tableView.reloadData() // blunt way
        }    
    }

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
    
    
    private struct Storyboard {
        static let ShowRecentSearchTweetsSegue = "Show RecentSearch Tweets"
        static let ShowMentionPopularitySegue = "Show Popularity"
        
    }
    

    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowRecentSearchTweetsSegue:
                if let destVC = segue.destination as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        destVC.searchText = cell.textLabel?.text
                    }
                }
            case Storyboard.ShowMentionPopularitySegue:
                if let destVC = segue.destination as? PopularityTableViewController {
                    if let cell = sender as? UITableViewCell {
                        destVC.searchText = cell.textLabel?.text
                    }
                }
            default:
                break
            }
        }
    }

}















