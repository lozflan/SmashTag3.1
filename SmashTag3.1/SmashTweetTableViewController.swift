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
    
    // class ONLY ADDS Twitter.Tweets to CoreData
    
    // MARK:- model
    var container: NSPersistentContainer? = AppDelegate.container

    /// Overrides insertTweets func of non-core data superclass to update coredata with new tweets array
    override func insertTweets(newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets: newTweets)
        updateDatabase(with: newTweets)
    }

    private func updateDatabase(with newTweets: [Twitter.Tweet]) {
        // update db off the mainQ. hands you an off-Q context
        print("about to load database")
        container?.performBackgroundTask { [weak self] (context) in
            for twitterInfo in newTweets {
                // create a factory func within Tweet to find an existing tweet or create a new one.
                // add the tweet to coredata
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics() // calling this func from oth queue
        }
    }
    
    
    // called from background queue above. Must do work on mainQ bc using viewContext
    private func printDatabaseStatistics() {
        if let context = container?.viewContext { // referencing viewcontext so need to ensure this runs on correct queue 
            context.perform { // good policy to always wrap context code in peform block
                Thread.isMainThread ? print("On main thread") : print("Off main thread")
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count{ //fetches all tweets then counts
                    print("\(tweetCount) tweets in coredata")
                }
                let tweeterRequest: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) { //used db side count = better than fetch then count above. 
                    print("\(tweeterCount) twitter users in coredata")
                }
            }
        }
    }
    
    
    
    
    
    // override pFS to add new functionality 
    //TODO: calling super may cause problem with switch breaking out of func before subclass switch gets chance to run??
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
//
//            default:
//                break
//            }
//        }
//    }
    
    

    
    


}





























