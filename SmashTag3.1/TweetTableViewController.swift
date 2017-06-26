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

    //outlets and related functionality
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            //set delegate when iboutlet set up
            searchTextField.delegate = self
            
            //reset searchTextField text if set before outlets set.
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //check if this message is coming from the searchTextField
        if textField == searchTextField {
                self.title = textField.text
                searchText = textField.text
        }
        return true
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        //call searchForTweets but within that func check if there is a newer search 
        searchForTweets()
        
    }
    
    


 
    //model 
    
    var tweets: [[Twitter.Tweet]] = [[]] {
        didSet {
//            print(tweets)
//            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil //reset to nil for refresh control 
            //reeset tweets array
            tweets.removeAll()
            tableView.reloadData() //reload will be light because table now empty.
            searchForTweets()
            title = searchText
            //save to recent searches
//            addSearchToStoredSearches() //lf way
            saveSearchTermToUserDefaults() //kt way 
        }
    }
    
    //model helper funcs 
    
    //create a valid twitter request
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query)", count: 100)
//            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 20)
            //original form of request below
//            return Twitter.Request(search: query, count: 10)
        }
        return nil
    }
    
    //MARK:- Main twitter search call
    
    //check if request still valid
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        //change next line for refresh control functionality. just checks if there is a newer form of Twitter.Request
        if let test = lastTwitterRequest?.newer {
        print("lastTwitterRequest.newer = \(test)")
        }
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
//            if let request = twitterRequest() { //orig request
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                //get mainQ
                DispatchQueue.main.async {
                    //new tweets returned. check if request still valid
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets)
                        self?.refreshControl?.endRefreshing()
                    }
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    //refactor code in searchForTweets to make more subclassable for coredata functionality
    func insertTweets(_ newTweets: [Twitter.Tweet]) {
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: UITableViewRowAnimation.fade)
    }
    

    //MARK: - Task8. save last 100 search terms persistently
//    let defaults = UserDefaults.standard
//    
//    //if stored searches exists in userdefaults, retrieve it ow create new
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
//    //called from searchText didSet
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
    
    //MARK: - Task 8 Following KT
    //Thursday, 8 June 2017 - KT way working but not uniquing
    //define recentSearches struct - do as separate file
    func saveSearchTermToUserDefaults() {
        if let searchText = searchText {
            RecentSearches.add(term: searchText)
        }
    }
 
    
    
    
    
    //lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchText == nil {
            searchText = "#sunset"
        }
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    //implement pop to rootVC of navcontroller functionality
    //Tuesday, 13 June 2017 - working thru how KT sets X button to show on tweetsTVC if deep in NC but not if at root.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPopToRootButton()
    }
    
    //controls whether or not the pop to root button shows. ie tweetTVC is the rootVC but could have gone round roundabout of mentions to get here so may or may not need to show
    func setPopToRootButton() {
        
        if let controllers = navigationController?.viewControllers, controllers.count >= 2 {
            let toRootButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                               target: self,
                                               action: #selector(toRootViewController))
            if let buttons = navigationItem.rightBarButtonItems{
                let con = buttons.flatMap{$0.action}.contains( #selector(toRootViewController))
                if !con { //dont think this ever fails ie con is always false so line above pointless?
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
        
        //Friday, 28 April 2017 - rather than cast cell above to TweetTableViewCell, do conditionally here to set the subclass's tweet var 
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
                    //pass the [[tweets]] array of arrays to the collectionView
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







