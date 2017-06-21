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
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    var cache: Cache?
    
    
    private func updateUI() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: url) {
                    //check url still relevant
                    if url == self?.imageURL {
                        if let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
//                                self?.cache?.setObject(imageData as NSData, forKey: url as NSURL, cost: imageData.count / 1024)// long way but seeing we defined subscript shortcut in ImagesCVC can use that instead ie ... 
                                //Wednesday, 21 June 2017. setting cache. try to understand how the subscripting works. 
                                self?.cache?[url] = imageData
                                self?.spinner.stopAnimating() //spinner may never stop?? how to overcome
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
}




