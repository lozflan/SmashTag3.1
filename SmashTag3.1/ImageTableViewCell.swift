//
//  ImageTableViewCell.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 16/5/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {


    @IBOutlet weak var mentionImageView: UIImageView!
    
    
    var urlString: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        mentionImageView?.image = nil
        if let newImg = fetchImage() {
            mentionImageView?.image = newImg
        }
    }
    
    private func fetchImage() -> UIImage? {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                ////FIXME: blocks mainQ
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    return image
                }
            }
        }
        return nil
    }


    
    
    
    
    
    
    //provided code
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
