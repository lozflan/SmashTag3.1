//
//  MentionsTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 9/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter
import SafariServices

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
//                return mediaItem.url.absoluteString
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
        
        var aspectRatio: Double {
            switch self {
            case .images(let mediaItem):
                return mediaItem.aspectRatio
            default:
                return 1.0
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
            mentionItems.insert(mediaItems, at: 0)
            mentionItems.insert(hashtags, at: 1)
            mentionItems.insert(urls, at: 2)
            mentionItems.insert(userMentions, at: 3)
            
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Sanjib Ahmad method
        let mention = mentionItems[indexPath.section][indexPath.row]
        switch mention {
        case .images(let media):
            return view.bounds.width / CGFloat(media.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
        
        //lf method. sanjibs way better because section is hardcoded here.
//        if indexPath.section == 0 {
//            //media items have an aspect ration from the image when tweetTVC originally loaded
//            let mediaItem = mentionItems[indexPath.section][indexPath.row]
//            let aspectRatio = mediaItem.aspectRatio
//            let width = view.bounds.width
//            let height = width / CGFloat(aspectRatio)
//            return height
//            
//        } else {
//            return UITableViewAutomaticDimension
//        }
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //need to deque up to 2 different types of cell - one for images and one for string mentions
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell", for: indexPath) as! ImageTableViewCell
            let mention  = mentionItems[indexPath.section][indexPath.row]
            switch mention {
            case .images(let media):
                cell.imageURL = media.url
            default:
                break
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mention Cell", for: indexPath)
            let mention = mentionItems[indexPath.section][indexPath.row]
            cell.textLabel?.text = mention.description
            return cell
        }
    }
    
    //control segue to tweetTVC from mention cells by shouldPerformSugue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //check if sender is url cell and if so dont perform From Keyword segue
        switch identifier {
        case "From Keyword": //did the name of this segue change ... does this need to change.
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let mention = mentionItems[indexPath.section][indexPath.row]
                    if case .urls(let url) = mention {
                        if let url = URL(string: url) {
//                            showURL(url: url)
                            self.performSegue(withIdentifier: "Show Webview", sender: sender)
                        }
                        return false
                    }
                }
            }
            return true
        default:
            return true
        }
    }
    
    //func to show url 
    func showURL(url:URL) {
        
        //lecturer method
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        }
        
//        //TK method. opens safari within your app.
//        let safariVC = SFSafariViewController(url: url)
//        present(safariVC, animated: true, completion: nil)
        
        
    }
    
    
    //prepareForSegue either back to TweetTVC if from keyword or to imageVC if from image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let mentionItem = mentionItems[indexPath.section][indexPath.row]
                    switch identifier {
                    case "From Keyword":
                        if let tweetTVC = segue.destination as? TweetTableViewController {
                            switch mentionItem {
                            case .hashtags(let hashtag):
                                tweetTVC.searchText = hashtag
                            case .users(let user):
                                tweetTVC.searchText = user
                            default:
                                break
                            }
                        }
                    case "Show Image":
                        if let imageVC = segue.destination as? ImageViewController {
                            if case .images(let mediaItem) = mentionItem {
                                //Wednesday, 31 May 2017
                                //the cell already contains an imageURL so reuse that 
                                if let cell = sender as? ImageTableViewCell {
                                    imageVC.imageURL = cell.imageURL
                                }
                            }
                        }
                    case "Show Webview":
                        if let webviewVC = segue.destination as? WebviewViewController {
                            //Wednesday, 14 June 2017. trying to pass url to webviewVC to show url in app cf in safari. 
                            if case .urls(let url) = mentionItem {
                                    webviewVC.url = URL(string: url)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
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
