//
//  SmashTweetTableViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 2/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//  SUBCLASS OF TWEETTVC TO KEEP TWEETTVC FUNCTIONALITY SANITISED


import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    
    //class adds Twitter.Tweets to CoreData
    
    //MARK:- model
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    

    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }

    private func updateDatabase(with newTweets: [Twitter.Tweet]) {
        //update db off the mainQ. hands you an off-Q context
        print("about to load database")
        container?.performBackgroundTask { [weak self] (context) in
            for twitterInfo in newTweets {
                //create a factory func within Tweet to find an existing tweet or create a new one.
                //add the tweet to coredata
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics() //calling this func from oth queue
        }
    }
    
    
    //called from background queue above 
    private func printDatabaseStatistics() {
        if let context = container?.viewContext { //referencing viewcontext so need to ensure this runs on correct queue 
            context.perform { //good policy to always wrap context code in peform block
                Thread.isMainThread ? print("On main thread") : print("Off main thread")
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count{
                    print("\(tweetCount) tweets in coredata")
                }
            }
        }
    }
    
    
    
    
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Tweeters Mentioning Search Term":
                if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                    tweetersTVC.mention = searchText
                    //                    tweetersTVC.container = container
                }
            case "Show Mentions":
                if let cell = sender as? UITableViewCell {
                    let mentionsTVC = segue.destination as? MentionsTableViewController
                    if let indexPath = tableView.indexPath(for: cell) {
//                        mentionsTVC?.tweet = tweets[indexPath.section][indexPath.row]
                    }
                }
            default:
                break
            }
        }
    }
    
    
    
    

//    //segue 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        
//        if let identifier = segue.identifier {
//            switch identifier {
//            case "Tweeters Mentioning Search Term":
//                if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
//                    tweetersTVC.mention = searchText
//                    tweetersTVC.container = container
//                }
//            default:
//                break
//            }
//        }
//        
//    }
    
    

    
    
    


}





























