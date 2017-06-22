//
//  ImageCollectionViewCell.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 19/6/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var cache: Cache?
    var imageURL: URL? {
        didSet {
            imageView.image = nil
            getImage()
        }
    }
    
    //lf revised using guard let <#name#> = <#code#> else {<#code#> return}
    private func getImage() {
        guard let url = imageURL else {return}
        spinner.startAnimating()
        //check if image cached bf fetching
        if let imageCache = cache?[url] {
            spinner.stopAnimating()
            imageView.image = UIImage(data: imageCache)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                //check url still relevant
                if url == self?.imageURL {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                            //self?.cache?.setObject(imageData as NSData, forKey: url as NSURL, cost: imageData.count / 1024)
                            //Wednesday, 21 June 2017. setting cache. try to understand how the subscripting works.
                            self?.cache?[url] = imageData
                            self?.spinner.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    

    //lf original way
//    private func getImage() {
//        if let url = imageURL {
//            spinner.startAnimating()
//            //check if image cached bf fetching
//            if let imageCache = cache?[url] {
//                spinner.stopAnimating()
//                imageView.image = UIImage(data: imageCache)
//            } else {
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    if let imageData = try? Data(contentsOf: url) {
//                        //check url still relevant
//                        if url == self?.imageURL {
//                            if let image = UIImage(data: imageData) {
//                                DispatchQueue.main.async {
//                                    self?.imageView.image = image
//                                    //self?.cache?.setObject(imageData as NSData, forKey: url as NSURL, cost: imageData.count / 1024)
//                                    // long way but seeing we defined subscript shortcut in ImagesCVC can use that instead ie ...
//                                    //Wednesday, 21 June 2017. setting cache. try to understand how the subscripting works.
//                                    self?.cache?[url] = imageData
//                                    self?.spinner.stopAnimating()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
    
    
    
}




