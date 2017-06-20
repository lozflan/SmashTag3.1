//
//  ImagesCollectionViewController.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 16/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter
private let reuseIdentifier = "Cell" //system required


//custom local struct containing the tweet, the media item (see twitter framework), and custom description

struct TweetMedia: CustomStringConvertible {
    var tweet: Twitter.Tweet
    var media: MediaItem  //tweets contain an array of media items so not sure why separate var media needed below
    var description: String {
        return "\(tweet) : \(media)"
    }
}




class ImagesCollectionViewController: UICollectionViewController {
    
    //our main model containing an array of TweetMedia struct
    private var images = [TweetMedia]()
    
    var tweets: [[Twitter.Tweet]] = [] {
        didSet {
            //Monday, 19 June 2017. converting [[tweets]] to flat array.
            //we have an array of arrays of tweet. want to flatten it to get array of tweets.
            //tweets contain an array of media items which themselves are a struct containing vars url, var aspectRatio and description
            //we want to convert them to our custom TweetMedia struct for the purposes of the collectionView
            
            images = tweets.flatMap({$0}) // flat array of tweets
                .map{ tweet in //map each tweet to [[MediaItem]]
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }} //map to create a new [[TweetMedia]]
                .flatMap({$0}) //flatten to [TweetMedia]
            
            
            //good breakdown explanation of images flatMap closure above
            
//            var images2 = tweets.flatMap{ $0 } //flat [Tweet] array
//            var medItemArray = images2.map { (tweet) in //now have [[MediaItem]]
//                tweet.media
//            }
//            var createdTweetMedia = images2.map{ (tweet) in //converts [[MediaItem]] to [[TweetMedia]]
//                tweet.media.map{ (media) in
//                    TweetMedia(tweet: tweet, media: media)
//                }}
//            var flatCreatedTweetMedia = createdTweetMedia.flatMap{ $0 } //converts [[TweetMedia]] to [TweetMedia] ie images var type.
//            images = flatCreatedTweetMedia
            
        }
    }
    


    
    
    
    
    
    

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
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo Cell", for: indexPath)
        
        // Configure the cell ... with if let for the specific photoCell code. allows returning cell not cell!
        if let photoCell = cell as? ImageCollectionViewCell {
//            photoCell.cache = cache
            photoCell.imageURL = images[indexPath.row].media.url
        }
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
