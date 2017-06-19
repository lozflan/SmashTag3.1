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
    
    private func updateUI() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let urlData = try? Data(contentsOf: url) {
                    //check url still relevant
                    if url == self?.imageURL {
                        if let image = UIImage(data: urlData) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
}




