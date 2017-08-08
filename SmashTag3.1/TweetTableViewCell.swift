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
        setProfileImageView(tweet: tweet)
        tweetTextLabel.text = tweet?.text
        // format tweet text. set the textLabels attributed text var
        let tweetText = formatTweetCellText()
        tweetTextLabel.attributedText = tweetText
        tweetCreatedLabel.text = formatCreatedDate()
    }
    
    
    private func setProfileImageView(tweet: Twitter.Tweet?) {
        tweetProfileImageView?.image = nil
        guard let tweet = tweet else {return}
        if let url = tweet.user.profileImageURL {
            // blocks the main queue
            // unable to put spinner in imageview so just take off mainQ as needed for now
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        //check fetch still relevant
                        if tweet.user.profileImageURL == url {
                            self.tweetProfileImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
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
    
    private struct MentionColor {
        static let hashtag = UIColor.red
        static let urls = UIColor.blue
        static let userMentions = UIColor.orange
        
    }
    
    /// Add colour to differnet types of user mention
    /// - returns: NSAttributedString: returns string with coloured mentions
    private func formatTweetCellText() -> NSMutableAttributedString {
        let mainString = tweet!.text
        let attributedString = NSMutableAttributedString(string: mainString)
        if let tweet = tweet {
 
            // lf-my solution. add the mention colour progressively to the attributedString
            _ = addMentionsColor(attribString: attributedString, mentions: tweet.hashtags, color: MentionColor.hashtag)
            _ = addMentionsColor(attribString: attributedString, mentions: tweet.urls, color: MentionColor.urls)
            _ = addMentionsColor(attribString: attributedString, mentions: tweet.userMentions, color: MentionColor.userMentions)
            
            // alternative solution using function declared within extension on NSAttributedString
//            attributedString.setMentionsColor(mentions: tweet.hashtags, color: MentionColor.hashtag)
//            attributedString.setMentionsColor(mentions: tweet.urls, color: MentionColor.urls)
//            attributedString.setMentionsColor(mentions: tweet.userMentions, color: MentionColor.userMentions)

        }
        return attributedString
    }
    
    /// Add colour to a mention. mentions are an array of one type of mention ie [hashtags] or [urls].
    /// mentions know their range within their containing string
    private func addMentionsColor(attribString: NSMutableAttributedString, mentions: [Twitter.Mention], color: UIColor) -> NSMutableAttributedString {
        let string = attribString
        for mention in mentions {
            string.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
        return string
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

extension NSMutableAttributedString {
    
    func setMentionsColor(mentions: [Twitter.Mention], color: UIColor ) {
        for mention in mentions {
            self.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
