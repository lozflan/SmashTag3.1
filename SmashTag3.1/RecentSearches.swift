// 
//  RecentSearches.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 8/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import Foundation


// searches struct 
import Foundation

// redoing recent searches for revision
// 3 functions ... 
// get array from user defaults for recentsearchesTVC
// save new search term from TweetTVC to user defaults
// delete a row from recentsearchesTVC is user swipes row left

struct RecentSearches {
    private static let defaults = UserDefaults.standard
    private static let defaultsKey = "RecentSearches"
    private static let limit = 100
    
    //computed var to return searches array from user defaults for caller
    static var searches: [String] {
        return defaults.array(forKey: defaultsKey) as? [String] ?? []
    }
    
    // add func to fetch defaults minus the curr searchTerm (if it exists) and insert the curr searchTerm at top of array
    static func add(_ searchTerm: String) {
        //validate searchTerm
        guard !searchTerm.isEmpty else {return}
        // returns the full recentSearches array minus the current searchTerm ie the != reverses the result. an == would just return an array with only that term if it existed in the orig array.
        var newArray = searches.filter { searchTerm.caseInsensitiveCompare($0) != .orderedSame }
        newArray.insert(searchTerm, at: 0)
        //implement limit
        while newArray.count > limit {
            newArray.removeLast()
        }
        // resave array overtop of existing
        defaults.set(newArray, forKey: defaultsKey)
    }
    
    static func removeAtIndex(_ index: Int) {
        var searchArray = searches
        searchArray.remove(at: index)
        defaults.set(searchArray, forKey: defaultsKey)
    }
}




struct RecentSearchesOrig {
    private static let defaults = UserDefaults.standard
    private static let key = "RecentSearches"
    private static let limit = 100
    
    static var searches: [String] {
        return (defaults.object(forKey: key) as? [String]) ?? []
    }
    
    static func add(_ term: String) {
        guard !term.isEmpty else {return}
        var newArray = searches.filter {term.caseInsensitiveCompare($0) != .orderedSame}
        newArray.insert(term, at: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey:key)
    }
    
    static func removeAtIndex(_ index: Int) {
        var currentSearches = (defaults.object(forKey: key) as? [String]) ?? []
        currentSearches.remove(at: index)
        defaults.set(currentSearches, forKey:key)
    }
}




