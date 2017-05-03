//
//  TwitterUser.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 2/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TwitterUser: NSManagedObject {
    
    class func findOrCreateTwitterUser(matching twitterInfo: Twitter.User, in context: NSManagedObjectContext) throws -> TwitterUser {
        let handle = twitterInfo.id
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        let predicate = NSPredicate(format: "handle = %@", handle)
        request.predicate = predicate
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "findOrCreateTwitterUser error - matches > 1")
                return matches[0]
            }
        } catch {
            throw error
        }
        //ow this twitterUser is not in database so create new one 
        let tweeter = TwitterUser(context: context)
        tweeter.handle = twitterInfo.id
        tweeter.name = twitterInfo.name
        return tweeter
        
    }
    
    
    
    
    

}





