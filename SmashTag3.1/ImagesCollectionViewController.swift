//
//  ImagesCollectionViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 16/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter
private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
    
    
    //get passed an array of array of tweets seeing we already hold exactly that in TweetTVC
    var tweets: [[Twitter.Tweet]]? {
        didSet {
            //Monday, 19 June 2017. converting [[tweets]] to flat array.
            tweets.flatMap { (<#[[Tweet]]#>) -> U? in
                <#code#>
            }
           
        }
    }
    
    //main data is a simple array of images and related data from newly defined struct TweetMedia
    var images: [TweetMedia]? {
        didSet {
            ////TODO:
        }
    }
    

    
    //a tweets media item is an array of MediaItem which is an imageURL, its aspectRatio, and a description. see MediaItem struct in Twitter framework.
    struct TweetMedia: CustomStringConvertible {
        var tweet: Twitter.Tweet?
        var media: MediaItem?
        var description: String {
            return "\(tweet) : \(media)"
        }
    }
    
    //
    
    
    
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo Cell", for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
