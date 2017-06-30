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


// MARK: - STRUCT

// custom local struct containing the tweet, the media item (see twitter framework), and custom description
struct TweetMedia: CustomStringConvertible {
    var tweet: Twitter.Tweet
    var media: MediaItem  // tweets contain an array of media items so not sure why separate var media needed too
    var description: String {
        return "\(tweet) : \(media)"
    }
}


// MARK: - CACHE CLASS

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


// MARK: - IMAGESCVC CLASS

class ImagesCollectionViewController: UICollectionViewController {
    
    // our main model containing an array of TweetMedia struct
    fileprivate var images = [TweetMedia]()
    
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

        // set installsStandardGestureForInteractiveMovement. 
        // default is true so dont need this line but making explict allows to set to false too
        installsStandardGestureForInteractiveMovement = true
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
    
    
    // override canMoveItemAt for re ordering cells
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Thursday, 29 June 2017 
    // override moveItemAt for re ordering cells and adjust datasource
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = images[destinationIndexPath.row]
        images[destinationIndexPath.row] = images[sourceIndexPath.row]
        images[sourceIndexPath.row] = tempItem
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
    
    
    
    // MARK: - RW ENLARGE SELECTED IMAGE
    // https://www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering
    
    //var to track indexPath of selected cell 
    var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths:[IndexPath] = []
            // if cell is selected add it to indexpath array
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }
            // if an old cell was previously selected, add this to the indexpath array too
            if let oldValue = oldValue {
                indexPaths.append(oldValue)
            }
            //relayout the collection view 
            if let largePhotoIndexPath = largePhotoIndexPath {
                collectionView?.performBatchUpdates({
                    self.collectionView?.reloadItems(at: indexPaths)
                }, completion: { (true) in
                    self.collectionView?.scrollToItem(at: largePhotoIndexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
                })
            }
        }
    }
    
    // disable normal collection view cell selection via delegate method 
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        // toggle the largePhotoIndexPath if tapped item is already the largePhotoIndexPath or not
//        largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
        // if you want to toggle enlarging and reducing photo, need to trigger largePhotoIndexPath didSetEach time rather than toggle
        largePhotoIndexPath = indexPath //tr
        
        
        return false
    }
    
    // resize the  large image using flow delegate method sizeForItemAt below ... 
    
    
    
    
    

    
}

















// MARK: UICollectionViewDelegate

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let usableWidth = collectionView.frame.size.width - (FlowLayout.minInterItemSpacing * (FlowLayout.columnCount - 1)) - FlowLayout.minSectionInset.left - FlowLayout.minSectionInset.right
        let thumbImageWidth = (usableWidth / FlowLayout.columnCount) * scale
        if largePhotoIndexPath == indexPath {
            //if cell currently thumbnail siz, enlarge, otherwise reduce. 
            let currCell = collectionView.cellForItem(at: indexPath)
            if currCell?.frame.size == CGSize(width: thumbImageWidth, height: thumbImageWidth) {
                let ratio = images[indexPath.row].media.aspectRatio
                let width = collectionView.bounds.size.width
                let height = width * CGFloat(ratio)
                return CGSize(width: thumbImageWidth * 2, height: thumbImageWidth * 2)
//                return CGSize(width: width, height: height)
            } else {
                return CGSize(width: thumbImageWidth, height: thumbImageWidth)
            }
        } else {
            return CGSize(width: thumbImageWidth, height: thumbImageWidth)
        }
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

















