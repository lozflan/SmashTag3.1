//
//  MentionsTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 9/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    var tweet: Twitter.Tweet? { didSet { updateUI() }}

    
    private func updateUI() {
        populateMentions()
        
    }
    
    //mentions are made up of 4 types images, hashtags, users, and urls. internal data structure to hold them perhaps an enum with dif assoc values 
    enum MentionItem {
        case images(MediaItem)
        case hashtags(String)
        case users(String)
        case urls(String)
        
        var description: String {
            switch  self {
            case .images(let mediaItem):
                return mediaItem.url.absoluteString
            case .hashtags(let hashtag):
                return hashtag
            case .users(let user):
                return user
            case .urls(let url):
                return url
            }
        }
        
        //var type to return a string for section header of the table.
        var type: String {
            switch  self {
            case .images:
                return "Images"
            case .hashtags:
                return "Hashtags"
            case .users:
                return "Users"
            case .urls:
                return "Urls"
            }
        }
    }
    
    // Define an array of array of mention items
    var mentionItems: [[MentionItem]] = [[]]
    
    // populate the mentions array
    private func populateMentions() {
        if let tweet = tweet {
            var mediaItems: [MentionItem] = []
            var hashtags: [MentionItem] = []
            var urls: [MentionItem] = []
            var userMentions: [MentionItem] = []
            
            //Friday, 12 May 2017 UP TO HERE 
            for media in tweet.media {
                let item = MentionItem.images(media)
                mediaItems.append(item)
            }
            for hashtag in tweet.hashtags{
                let item = MentionItem.hashtags(hashtag.keyword)
                hashtags.append(item)
            }
            for url in tweet.urls {
                let item = MentionItem.urls(url.keyword)
                urls.append(item)
            }
            for userMention in tweet.userMentions {
                let item = MentionItem.users(userMention.keyword)
                userMentions.append(item)
            }
            mentionItems.insert(hashtags, at: 0)
            mentionItems.insert(urls, at: 1)
            mentionItems.insert(userMentions, at: 2)
            
            //now i have an array of arrays of mentionitem but how to extract the assoc value.
            
            
        }
    }
    
    
    

    
    
    
    //MARK: - Lifecycle functions
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return mentionItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionItems[section].first?.type
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentionItems[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mention Cell", for: indexPath)
        cell.textLabel?.text = mentionItems[indexPath.section][indexPath.row].description
        //Thursday, 11 May 2017 UP TO HERE
        return cell
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
