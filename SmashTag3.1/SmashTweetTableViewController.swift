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
        //main role of subclass to override insertTweets and save to coredata
        updateDatabase(with: newTweets)
        
    }

    
    /// Takes array of twitterTweets and saves data to coredata
    private func updateDatabase(with twitterTweets: [Twitter.Tweet]) {
        // update db off the mainQ. hands you an off-Q context
        print("about to load database")
        // load on background queue
        container?.performBackgroundTask { [weak self] (context) in
            for twitterTweet in twitterTweets {
                // call factory func within Tweet to find an existing tweet in database or create a new one in database
                if let (cdTweet,new) = try? Tweet.findOrCreateTweet(matching: twitterTweet, in: context), new == true {
                    // if tweet returned and if tweet is new, add mention to coredata for this tweet
                    self?.updateMentions(twitterTweet: twitterTweet, cdTweet: cdTweet)
                }
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics() // calling this func from oth queue
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            print("core data path = \(paths[0])")
        }
    }
    
    private struct MentionType {
        static let hashtag = "hashtag"
        static let userMention = "userMention"
    }
    
    
    /// Call Mention MOSubclass static functions to manage creating or incrementing mentions
    private func updateMentions(twitterTweet: Twitter.Tweet, cdTweet: Tweet) {
        if let searchText = searchText {
            for hashtag in twitterTweet.hashtags {
                _ =  try? Mention.checkMention(keyword: hashtag.keyword, searchText: searchText, cdTweet: cdTweet, type: MentionType.hashtag)
            }
            for userMention in twitterTweet.userMentions {
                _ =  try? Mention.checkMention(keyword: userMention.keyword, searchText: searchText, cdTweet: cdTweet, type: MentionType.userMention)
            }
            
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
                let mentionRequest: NSFetchRequest<Mention> = Mention.fetchRequest()
                if let mentionCount = try? context.count(for: mentionRequest) {
                    print("\(mentionCount) mentions in database")
                }
            }
        }
    }
    
    


    
    


}





























