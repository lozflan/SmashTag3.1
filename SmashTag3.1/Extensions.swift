//
//  Extensions.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 7/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import Foundation
import UIKit


//MARK: - TabbarController extensions

extension UITabBarController {
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask     {
        return .all
    }
}


//MARK: - ARRAY EXTENSIONS 

//https://stackoverflow.com/questions/25738817/does-there-exist-within-swifts-api-an-easy-way-to-remove-duplicate-elements-fro

//Array - remove duplicates / uninque an array retaining order of elements

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}
//Can be called like this:
//let arrayOfInts = [2, 2, 4, 4]
//print(arrayOfInts.removeDuplicates()) // Prints: [2, 4]






