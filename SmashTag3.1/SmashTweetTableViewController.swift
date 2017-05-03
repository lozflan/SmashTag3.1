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
        container?.performBackgroundTask { (context) in
            for twitterInfo in newTweets {
                //create a factory func within Tweet to find an existing tweet or create a new one. 
                //add the tweet to coredata 
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
        
        }
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            if let tweetCount = (try? context.fetch(request))?.count{
                print("\(tweetCount) tweets in coredata")
            }
                
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    


}
