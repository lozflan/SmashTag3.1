//
//  TweetTableViewCell.swift
//  SmashTag3.1
//
//  Created by Lawrence Flancbaum on 28/4/17.
//  Copyright © 2017 Cloudmass. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
 
    
    var tweet: Twitter.Tweet? { didSet { updateUI() }}
    
    private func updateUI() {
        tweetUserLabel.text = tweet?.user.name
        tweetProfileImageView.image = getProfileImage()
        tweetTextLabel.text = tweet?.text
        tweetCreatedLabel.text = formatCreatedDate()
    }
    
    private func getProfileImage() -> UIImage? {
        
        if let url = tweet?.user.profileImageURL {
            ///FIXME: blocks the main queue
            if let imageData = try? Data(contentsOf: url) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    private func formatCreatedDate() -> String? {
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) < 24*60*60 {
                formatter.timeStyle = .short
            } else {
                formatter.dateStyle = .short
            }
            return formatter.string(from: created)
        } else {
            return nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
