//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Michael Brennan on 16/03/2017.
//  Copyright © 2017 Michael Brennan. All rights reserved.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {
    
    
    //Mark: -Data Model
    var tweets = [[TwitterTweet]]()
    
    //Set the default twitter search value to ucd and the didset clear out the previous tweets to reloads the new data in the tableView
    var twitterQueryText: String? = "#ucd" {
        didSet {
            lastSuccessfulRequest = nil
            twitterQueryTextField?.text = twitterQueryText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    //Textfield outlet to search that the user input
    @IBOutlet weak var twitterQueryTextField: UITextField!
        {
        didSet{
            twitterQueryTextField.delegate = self
            twitterQueryTextField?.text = twitterQueryText
            
            
        }
        
    }
    
    //Updates the twitterQueryText property
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == twitterQueryTextField {
            textField.resignFirstResponder()
            twitterQueryText = textField.text
        }
        return true
    }
    
    
    private var lastSuccessfulRequest: TwitterRequest?
    
    private var nextRequestToAttempt: TwitterRequest? {
        guard (lastSuccessfulRequest != nil) else {
            guard (twitterQueryTextField != nil) else {
                return nil
            }
            return TwitterRequest(search: twitterQueryText!, count: 100)
        }
        return lastSuccessfulRequest!.requestForNewer
    }
    
    
    
    //Updating the data model tweets
    private func refresh(_ sender: UIRefreshControl?) {
        guard let request = nextRequestToAttempt else {
            sender?.endRefreshing()
            return
        }
        request.fetchTweets { (newTweets) -> Void in
            DispatchQueue.main.async { () -> Void in
                if newTweets.count > 0 {
                    self.lastSuccessfulRequest = request
                    self.tweets.insert(newTweets, at: 0)
                    self.tableView.reloadData()
                }
                sender?.endRefreshing()
            }
        }
    }
    
    
    
    func refresh() {
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    
    
    
    //Initialising the tableView estimatedRowHeight
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Table view data source
    
    
    
    //Returns the number of sections to the tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    
    //Returns the number of rows to the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataCell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTVCell
        
        // Configure the cell..
        dataCell.showTweets = tweets[indexPath.section][indexPath.row]
        
        
        return dataCell
    }
    
}
