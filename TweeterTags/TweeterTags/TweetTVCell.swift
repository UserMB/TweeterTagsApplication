//
//  TweetTVCell.swift
//  TweeterTags
//
//  Created by Michael Brennan on 16/03/2017.
//  Copyright © 2017 Michael Brennan. All rights reserved.


import UIKit

class TweetTVCell: UITableViewCell {
    
    //Property that sets updateCell methods to be used in the TweetsTVC tableView func
    var showTweets: TwitterTweet? {
        didSet {
            updateCell()
        }
        
    }
    
    //The outlets to set the following info from the tweeter to the table cell
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetUserName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    
    private func updateCell() {
        
        tweetUserName?.text = "\(showTweets!.user)" // showTweets.user.description
        tweetText?.text = showTweets!.text //showTweets.user.text
        tweetDate?.text = "\(showTweets!.created)" //showTweets.user.created(time/data)
        
        //showTweets.user.profileImageUrl
        if let imageURl = showTweets?.user.profileImageURL {
            
            if let imageData = try? Data(contentsOf: imageURl as URL) {
                tweetImage?.image = UIImage(data: imageData)
            }else {
                tweetImage?.image = nil
            }
            
            
            //Highlighting hashtag, url and mentions
            let hashtags = showTweets?.hashtags
            let urls = showTweets?.urls
            let mentions = showTweets?.userMentions
            let attributedString = NSMutableAttributedString(string:showTweets!.text)
            
            for hashtag in hashtags!{
                let range = (showTweets!.text as NSString).range(of: hashtag.keyword)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue , range: range)
            }
            for url in urls!{
                let range = (showTweets!.text as NSString).range(of: url.keyword)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
            }
            for mention in mentions!{
                let range = (showTweets!.text as NSString).range(of: mention.keyword)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green , range: range)
            }
            tweetText?.attributedText = attributedString
        }
    }
}
