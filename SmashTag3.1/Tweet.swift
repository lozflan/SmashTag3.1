// 
//  Tweet.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 2/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> (Tweet, new: Bool) {
        // create a fetchreq to see if the tweet is already in the database
        let unique = twitterInfo.identifier
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        let predicate = NSPredicate(format: "unique = %@", unique)
        request.predicate = predicate
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "findOrCreateTweet error - matches > 1")
                return (matches[0], false)
            }
        } catch {
            throw error
        }
        // ow this tweet is NOT in database so create new one
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context) // just ignoring if tweeter not created and really probably want all to fail if this occured otherwise youll be adding tweets to coredata with no tweeter assigned.
        return (tweet, true)
    }
    
    
    /// Checks if a Mention (searchTerm-keyword combo) is in coredata  and if so increments the count if mentioned in a  new tweet or creates if not in coredata. called from here bc you have a handle to the cdTweet
    class func findTweetAndCheckMentions(twitterTweet: Twitter.Tweet, cdTweet: Tweet) {
        
    }
    
    
    /// Takes an array of tweets and replicates findOrCreateTweet functionality for batch processing.
    class func findOrCreateMultipleTweets(tweets: [Twitter.Tweet], context: NSManagedObjectContext) -> throws [Tweet] {
        
        //get array of tweet identifiers
        let identifiers = tweets.map { $0.identifier }
        
    }
    
    

}











