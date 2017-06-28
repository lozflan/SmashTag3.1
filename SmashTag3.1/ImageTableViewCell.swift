// 
//  ImageTableViewCell.swift
//  SmashTag3.1
// 
//  Created by Lawrence Flancbaum on 16/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
// 

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {


    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
 
    
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI() {

        if let imageURL = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        if imageURL == self?.imageURL {
                            let image = UIImage(data: imageData)
                            self?.tweetImage.image = image
                        }
                        self?.spinner.stopAnimating()
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // provided code
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
