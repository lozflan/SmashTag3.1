// 
//  ImageViewController.swift
//  Cassini
// 
//  Created by Lawrence Flancbaum on 15/08/2016.
//  Copyright © 2016 Cloudmass. All rights reserved.
// 

import UIKit

class ImageViewController: UIViewController {


    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // connect the scrollview to the vc
    @IBOutlet weak var scrollView: UIScrollView! {
        // 10. did set best place to configure the scroll view
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 3.0
            
        }
    }
    
    // add autozoom to fit to base casinni functionality 
    // var to check if zoom has been amended
    fileprivate var autoZoomed = true
    
    // func to adjust zoom if needed
    private func zoomScaleToFit() {
        if !autoZoomed {
            return
        }
        if let sv = scrollView, image != nil && (imageView.bounds.size.width > 0) && (sv.bounds.size.width > 0) {
            let heightRatio = self.view.bounds.size.height / imageView.bounds.size.height
            let widthRatio = self.view.bounds.size.width / imageView.bounds.size.width
            sv.zoomScale = (heightRatio > widthRatio) ? heightRatio : widthRatio
            sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width)/2,
                                       y: (imageView.frame.size.height - sv.frame.size.height)/2)
            autoZoomed = false
            
        
        }
    }
    

    
    
    


    // 1. think about model - in this case image url is the model and this is set from prepareforsegue from cassiniVC. if imageurl gets set want to set existing image to nil and fetch new image. this is a stored var (optional) with a setter observer.

    var imageURL: URL? {
        didSet {
            image = nil
            // check if view onscreen before doing expensive fetch bc here this fetch will occur asa imageURL is set irrespective of whether the view is going to appear.
            if view.window != nil { // reliable way to tell if you are onscreen ... but if you do this you now also have to check if you are about to go onscreen and if so run fetch image - do so in view will appear
                fetchImage()
            }
        }
    }

    // 2. see above. run fetchimage again to ensure its either called there (if url set whilst we are onscreen) or here if we werent onscreen when imageURL didSet called

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }




    // 3. fetches image and dont need to take param or return nsdata cause can just set the var directly. if image fetched ok, wll set self.image to the image

    fileprivate func fetchImage()  {
        if let url = imageURL { // checks that youve got a real url
            spinner?.startAnimating()

            // dispatch get global queue
            let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
            globalQueue.async { [weak self] in // prevents self from being strongly captured so if closure returns and enitre mvc is gone then it would be fine bc self would be let go bc only weakly held here
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    // check if fetched item still current
                    if url == self?.imageURL {  // whilst fetching, user might have clicked on other button changing the desired imageURL, check if the fetched url matches the current url
                        // run on the main queue
                        if let imgData = contentsOfURL {
                            // set the image using the fetched data triggering image setter
                            self?.image = UIImage(data: imgData)
                        } else {
                            // no data within fetched image and image not set so stop spinner
                            self?.spinner?.stopAnimating()
                        }
                    } else {
                        // url doesnt match current imageURL
                        print("url doesnt match current imageURL")
                    }
                }
            }
        }
    }





    // 4. create image view in code which will have 0 size and trick is to have computed image var which sets the image of the image view and sizes the image view to the size of that image when the image is set 

    var imageView = UIImageView() // size = 0,0,0,0 when created


    // kill 2 birds ie set imageview's image and set image view size. computed var that "stores" its value within the imageView in its setter and also sets the size of the imageView whenever it is set. remember computed var has no storage itself but here acts as gatekeeper for stored imageView var
    fileprivate var image: UIImage? {
        get { return imageView.image }
        set {
            // computed var can refer to self bc called after instance exists.
            imageView.image = newValue
            imageView.sizeToFit()

            // also now we know image size we can set the scrollview content size with optional chainging if where outlet not yet connected ie imageurl set from prepareforsegue
            scrollView?.contentSize = imageView.bounds.size
            spinner?.stopAnimating()
            
            // autofit BEST PLACE FOR THIS?
            // Monday, 5 June 2017 need to work thru this to learn more how it works and if its working
            autoZoomed = true
            zoomScaleToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // add the imageview as a subview to the scrollview in vdl but remember bounds not set
        scrollView?.addSubview(imageView)

        // testing - set the image url starting off the whole process
//        imageURL = NSURL(string: "https:// engineering.stanford.edu/sites/default/files/styles/full-width-banner-short/public/QuadNew-cropped.png?itok=rQiRy977")

        // testing introspection getting prop names obj c extension (seeObjCExtensions file) using http:// derpturkey.com/get-property-names-of-object-in-swift/

//        let props = self.propertyNames()
//        print(props)

    }
    
    
    // delegate method - called when view geometry changes so call zoomScaleToFit here again.
    override func viewDidLayoutSubviews() {
        zoomScaleToFit()
    }
    



    
    
}

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // /

extension ImageViewController : UIScrollViewDelegate {
    // asks scrollview delegate for the view to scale when zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    // delegate method called just before user zooming starts
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoomed = false // prevents autozoom occuring after user takes over zoom control
    }
}





