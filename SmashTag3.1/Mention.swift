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
    
    /// Check coredata for a searchTerm and add or increment all the mentions contained in a tweet into core data.
    
    class func updateOrAddMention(keyword: String, searchTerm: String, newTweet: Twitter.Tweet, type: String, context: NSManagedObjectContext) throws -> Mention {
        //create a fetch request
        let predicate = NSPredicate(format: "keyword = [cd] %@ AND searchTerm = [cd] %@" , keyword, searchTerm )
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = predicate
        
        //Friday, 11 August 2017 UP TO HERE
        
        do {
            let matches = try context.fetch(request)
            //no db error. check results
            if matches.count > 0 {
//                assert(matches.count == 1, "mentions.count > 1 error" )
                //increemnt the count
                matches[0].count += 1
                //return the Mention
            }
        } catch {
            throw error
        }
        //ow no matching Mention in coredata so create one
        let mention = Mention(context: context)
        mention.keyword = keyword
        mention.searchTerm = searchTerm
        mention.type = type
        return mention
        
        
    }
    
    
    
}
