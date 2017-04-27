//
//  TweetTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 27/4/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter


class TweetTableViewController: UITableViewController {

 
    //model 
    
    private var tweets: [[Twitter.Tweet]] = [[]] {
        didSet {
//            print(tweets)
//            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            //reeset tweets array
            tweets.removeAll()
            tableView.reloadData() // reload will be light because table now empty.
            searchForTweets()
            title = searchText
        }
    }
    
    //model helper funcs 
    
    //create a valid twitter request
    private func twitterRequest() -> Twitter.Request? {
        if let searchText = searchText, !searchText.isEmpty {
            return Twitter.Request(search: searchText, count: 10)
        }
        return nil
    }
    
    //check if request still valid
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                //get mainQ
                DispatchQueue.main.async {
                    //new tweets returned. check if request still valid
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: UITableViewRowAnimation.fade)
                    }
                }
            }
        }
    }
    

    
    
    //lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#stanford"
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tweets[indexPath.section][indexPath.row].text
        cell.detailTextLabel?.text = tweets[indexPath.section][indexPath.row].user.name
        

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
