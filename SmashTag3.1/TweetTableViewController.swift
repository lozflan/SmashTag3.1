// 
//  TweetTableViewController.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 27/4/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import UIKit
import Twitter


class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    // outlets and related functionality
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            // set delegate when iboutlet set up
            searchTextField.delegate = self
            // reset searchTextField text if set before outlets set.
            searchTextField.text = searchText
        }
    }
    
    // uitextfielddelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // check if this message is coming from the searchTextField
        if textField == searchTextField {
                self.title = textField.text
                searchText = textField.text
        }
        return true
    }
    
    
    // MARK: - Model
    // an array of array of tweets 
    // suited for tableviewController
    private var tweets = [Array<Twitter.Tweet>]()
//    private var tweets: [[Twitter.Tweet]] = [[]]
    
    // public model to pass a single tweet within an array from ImagesCVC
    // so it can be added to tweets array of arrays at index 0
    var newTweets: [Twitter.Tweet] = [] {
        didSet {
            tweets.insert(newTweets, at: 0)
            tableView.insertSections([0], with: .fade)
        }
    }
    
    // model search string set from search text field
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil // reset to nil for refresh control 
            // reeset tweets array
            tweets.removeAll()
            tableView.reloadData() // reload will be light because table now empty.
            searchForTweets()
            self.title = searchText
            // save to recent searches
            if let searchText = searchText {
                RecentSearches.add(term: searchText) // kt way. struct RecentSearches in separate file
                // addSearchToStoredSearches() // lf way
            }
        }
    }
    
    
    // MARK: - Model helper funcs
    
    // create a valid twitter request
    // fetching tweets matching our searchText
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query)", count: 20)
//            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 20)
        }
        return nil
    }
    
    // check if request still valid. we track this so that
    // a) we ignore tweets that come back from other than our last request
    // b) when we want to refresh, we only get tweets newer than our last request
    private var lastTwitterRequest: Twitter.Request?
    
    // main twitter search call
    // takes the searchText part of our Model
    // and fires off a fetch for matching Tweets
    // when they come back (if they're still relevant)
    // we update our tweets array
    // and then let the table view know that we added a section
    // (it will then call our UITableViewDataSource to get what it needs)
    private func searchForTweets() {
        // for refresh control functionality. just checks if there is a newer form of Twitter.Request
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in //off the main q
                DispatchQueue.main.async {
                    // new tweets returned. check if request still valid
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets: newTweets)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // refresh control. added after refresh lecture
    @IBAction func refresh(_ sender: UIRefreshControl) {
        // call searchForTweets but within that func check if there is a newer search
        searchForTweets()
    }
    
    // refactored code in searchForTweets to make more subclassable for coredata functionality
    func insertTweets(newTweets: [Twitter.Tweet]) {
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: UITableViewRowAnimation.fade)
    }
    
    
    // MARK: - ViewController lifecycle
    // Wednesday, 28 June 2017 going thru code to tidy up and work out why tableview error when inserting newTweets section.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if there are no tweets, show the last search text used 
//        if tweets.count == 0 {
//            if searchText == nil, let searchLast = RecentSearches.searches.first {
//                searchText = searchLast
//            } else {
//                searchTextField?.text = searchText
//                searchTextField?.resignFirstResponder()
//            }
//        }
        // old hardcoded
        if searchText == nil {
            searchText = "#sunset"
        }
        // tableview row height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    // implement pop to rootVC of navcontroller functionality
    // Tuesday, 13 June 2017 - working thru how KT sets X button to show on tweetsTVC if deep in NC but not if at root.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPopToRootButton()
    }
    
    // controls whether or not the pop to root button shows. 
    // ie tweetTVC is the rootVC but could have gone round roundabout of mentions to get here 
    // so may or may not need to show
    func setPopToRootButton() {
        if let controllers = navigationController?.viewControllers, controllers.count >= 2 {
            let toRootButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                               target: self,
                                               action: #selector(toRootViewController))
            if let buttons = navigationItem.rightBarButtonItems{
                let con = buttons.flatMap{$0.action}.contains( #selector(toRootViewController))
                if !con { // dont think this ever fails ie con is always false so line above pointless?
                    let rightBarButtons = [toRootButton] + buttons
                    navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
                }
            } else {
                let rightBarButtons = [toRootButton]
                navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
            }
        }
        
        
    }
    
    func toRootViewController() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    deinit {
    
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
        let tweet = tweets[indexPath.section][indexPath.row]
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        // Friday, 28 April 2017 rather than cast cell above to TweetTableViewCell, 
        // do conditionally here to set the subclass's tweet var
        // that allows cell to be returned below as non-optional
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count)"
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        code
//    }

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

    

    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show All Images":
                if let destVC = segue.destination as? ImagesCollectionViewController {
                    // pass the [[tweets]] array of arrays to the collectionView
                    destVC.tweets = tweets
                    
                }
            case "Show Mentions":
                if let cell = sender as? UITableViewCell {
                    let mentionsTVC = segue.destination as? MentionsTableViewController
                    if let indexPath = tableView.indexPath(for: cell) {
                        mentionsTVC?.tweet = tweets[indexPath.section][indexPath.row]
                    }
                }
            default:
                break
            }
        }
    }


    
    
    
}



extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
















// MARK: - Task8. save last 100 search terms persistently
//    let defaults = UserDefaults.standard
//
//    // if stored searches exists in userdefaults, retrieve it ow create new
//    var udRecentSearches: [String] {
//        get {
//            if let defaultsSearches = defaults.value(forKey: "RecentSearches") as? [String] {
//                return defaultsSearches
//            }
//            else {
//                return []
//            }
//        }
//    }
//
//    var storedSearches: [String] = []
//
//
//    // called from searchText didSet
//    func addSearchToStoredSearches() {
//        if let searchText = searchText {
//            if udRecentSearches.count > 0 {
//                storedSearches = udRecentSearches
//            }
//            if !storedSearches.contains(searchText) {
//                storedSearches.insert(searchText, at: 0)
//                if storedSearches.count > 100 {
//                    storedSearches.remove(at: 99)
//                }
//            }
//        print(storedSearches)
//        defaults.set(storedSearches, forKey: "RecentSearches")
//        print( "defaults are  \(defaults.value(forKey: "RecentSearches") as? [String] ?? ["oops"]) "  )
//        }
//    }
