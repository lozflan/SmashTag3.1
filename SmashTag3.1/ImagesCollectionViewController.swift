// 
//  ImagesCollectionViewController.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 16/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import UIKit
import Twitter
private let reuseIdentifier = "Cell" // system required


// custom local struct containing the tweet, the media item (see twitter framework), and custom description
struct TweetMedia: CustomStringConvertible {
    var tweet: Twitter.Tweet
    var media: MediaItem  // tweets contain an array of media items so not sure why separate var media needed too
    var description: String {
        return "\(tweet) : \(media)"
    }
}


// define the photo cache here. init one in the ImageCVC class, pass it to the ImageCVCell in cellForRowAt, set and or read it in the ImageCVCell class.
class Cache: NSCache<NSURL, NSData> {
    subscript(key: URL) -> Data? { // give cache a url and get back Data?
        get{
            return self.object(forKey: key as NSURL) as Data?
        }
        set{
            if let data = newValue {
                self.setObject(data as NSData, forKey: key as NSURL, cost: data.count / 1024) // nscache deals with nsurl not urls
            } else {
                removeObject(forKey: key as NSURL) // why do we hae to remove if data condbinding fails??
            }
        }
    }
}



class ImagesCollectionViewController: UICollectionViewController {
    
    // our main model containing an array of TweetMedia struct
    private var images = [TweetMedia]()
    
    // cache
    var cache = Cache()
    
    
    var tweets: [[Twitter.Tweet]] = [] {
        didSet {
            // Monday, 19 June 2017. converting [[tweets]] to flat array.
            // we have an array of arrays of tweet. want to flatten it to get array of tweets.
            // tweets contain an array of media items which themselves are a struct containing vars url, var aspectRatio and description
            // we want to convert them to our custom TweetMedia struct for the purposes of the collectionView
            
            images = tweets.flatMap({$0}) // flat array of tweets
                .map{ tweet in // map each tweet to [[MediaItem]]
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }} // map to create a new [[TweetMedia]]
                .flatMap({$0}) // flatten to [TweetMedia]
            
            
            // good breakdown explanation of images flatMap closure above
            
//            var images2 = tweets.flatMap{ $0 } // flat [Tweet] array
//            var medItemArray = images2.map { (tweet) in // now have [[MediaItem]]
//                tweet.media
//            }
//            var createdTweetMedia = images2.map{ (tweet) in // converts [[MediaItem]] to [[TweetMedia]]
//                tweet.media.map{ (media) in
//                    TweetMedia(tweet: tweet, media: media)
//                }}
//            var flatCreatedTweetMedia = createdTweetMedia.flatMap{ $0 } // converts [[TweetMedia]] to [TweetMedia] ie images var type.
//            images = flatCreatedTweetMedia
//            print(flatCreatedTweetMedia.first?.tweet.description)
            
        }
    }
    
    // Tuesday, 27 June 2017 - create a scale var to scale the CVCell size
    fileprivate var scale: CGFloat = 1.0 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // configure the gesture recognizer
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer! {
        didSet {
            pinchGestureRecognizer.addTarget(self, action: #selector(ImagesCollectionViewController.handlePinch(recognizer:)))
        
        }
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        print("\(scale)")
        switch recognizer.state {
        case .changed, .ended:
            self.scale *= pinchGestureRecognizer.scale
            pinchGestureRecognizer.scale = 1.0
        default:
            break 
        }
    }
    

    
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    // Monday, 26 June 2017 - override to reload collview and force recalc of columns between portrait and landscape
    // https:// stackoverflow.com/questions/41659646/get-the-current-device-orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super .viewWillTransition(to: size, with: coordinator)
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private struct Storyboard {
        static let ShowTweetSegue = "Show Tweet"
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowTweetSegue:
                if let destVC = segue.destination as? TweetTableViewController {
                    if let cell = sender as? ImageCollectionViewCell {
                        if let indexPath = collectionView?.indexPath(for: cell) {
                            let newTweetArray = [images[indexPath.row].tweet]
                            destVC.newTweets = newTweetArray
                        }
                    }
                }
            default:
                break
            }
        }
    }

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
            photoCell.spinner.stopAnimating() // always stop spinner incase reusing cell.
            photoCell.cache = cache // pass the cache instance
            photoCell.imageURL = images[indexPath.row].media.url
        }
        return cell
    }
    
    
    
    
    // MARK: - Flowlayout 
    
    fileprivate struct FlowLayout {
        static let minimumImageCellWidth: CGFloat = 60.0
        static var columnCount: CGFloat {
            get {
                switch UIDevice.current.orientation {
                case .portrait, .portraitUpsideDown:
                    return 4
                case .landscapeRight, .landscapeLeft:
                    return 7
                default:
                    return 4
                }
            }
        }
        static let minColumnSpacing: CGFloat = 1
        static let minInterItemSpacing: CGFloat = 1
        static let minSectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // implemented by TK to do final cell size calcs but not LF because happy with keeping cells square.
//    fileprivate func setupCustomLayout() {
//        let layoutFlow = UICollectionViewFlowLayout()
//        layoutFlow.minimumInteritemSpacing = FlowLayout.minInterItemSpacing
//        layoutFlow.itemSize = CGSize(width: 60, height: 60) // would need to implement a way to calc item size if you want in future.
//        // set the collview's layout to the custom version 
//        collectionView?.collectionViewLayout = layoutFlow
//    }
    
    
    

    
}

















// MARK: UICollectionViewDelegate

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let usableWidth = collectionView.frame.size.width - (FlowLayout.minInterItemSpacing * (FlowLayout.columnCount - 1)) - FlowLayout.minSectionInset.left - FlowLayout.minSectionInset.right
        let imageWidth = (usableWidth / FlowLayout.columnCount) * scale
        return CGSize(width: imageWidth, height: imageWidth)
    }

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

















