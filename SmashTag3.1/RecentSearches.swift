//
//  RecentSearches.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 8/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import Foundation


//searches struct 
struct RecentSearches {
    
    static let defaults = UserDefaults.standard
    static let key = "RecentSearches"
    static let limit = 100
    
    //static var
    static var searches: [String] {
        return defaults.value(forKey: key) as? [String] ?? []
    }
    
    
    //add static func to add searchTerms to the searches array
    //called from searchText didSet in tweetTVC
    static func add(term: String) {
        //check if term already in array
        guard !term.isEmpty else {return}
        //filter better than using contains bc can find and strip out if term exists. orderedSame just means if $0 and term are equal.
        var newArray = searches.filter { $0.caseInsensitiveCompare(term) != .orderedSame }
        print("new array = \(newArray)")
        newArray.insert(term, at: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        //save to userdefaults
        defaults.set(newArray, forKey: key)
    }
    
    
    
    
    
    
    
    
    
    
}




