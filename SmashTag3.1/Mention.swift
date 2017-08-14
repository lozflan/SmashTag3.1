//
//  Mention.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 9/8/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Mention: NSManagedObject {
    
    /// Calls findOrCreateMention but adds check to see if the tweet already exists in the returned mention's tweet array ie dont add or increment the mention count if this tweet's mentions have already been counted.
    static func checkMention(keyword: String, searchText: String, cdTweet: Tweet, type: String) throws -> Mention {
        do {
            let mention = try findOrCreateMention(keyword: keyword, searchText: searchText, type: type, context: cdTweet.managedObjectContext!)
//            print("Main thread = \(Thread.isMainThread)")
            // get the mention's tweet array and check that this tweet doesnt already exist in the array
            if let tweetSet = mention.tweets, !tweetSet.contains(cdTweet) {
                //add the tweet to the array and increment the mention count
                mention.addToTweets(cdTweet)
                mention.count += 1
            }
            return mention
        } catch {
            throw error
    }
}




    /// Checks coredata for a searchTerm and mentionn combination. retuns one if found, otherwise creates new one.
    static func findOrCreateMention(keyword: String, searchText: String, type: String, context: NSManagedObjectContext) throws -> Mention {
        //create a fetch request
        let predicate = NSPredicate(format: "keyword = [cd] %@ AND searchTerm = [cd] %@" , keyword, searchText )
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = predicate
        
        do {
            let mentionMatch = try context.fetch(request)
            //no db error. check results
            if mentionMatch.count > 0 {
                // there should only ever be 0 or 1 matches
                assert(mentionMatch.count == 1, "mentions.count > 1 error" )
                //increemnt the count
                return mentionMatch[0]
            } else {
                //ow no matching Mention in coredata so create one
                let newMention = Mention(context: context)
                newMention.keyword = keyword
                newMention.searchTerm = searchText
                newMention.type = type
                return newMention
            }
        } catch {
            //throw error  back to caller and let them decide how to deal with error
            throw error
        }
    }
    
    
    
}
