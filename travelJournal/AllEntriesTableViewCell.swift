//
//  AllEntriesTableViewCell.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class AllEntriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var allEntriesCellLabel: UILabel!
    @IBOutlet weak var allEntriesLabelDescription: UILabel!
    @IBOutlet weak var allEntriesImageView: UIImageView!
    
    @IBOutlet var heartAnimationView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var journalObject:JournalModel? {
        
        // didSet is run when we set this variable in FeedViewController
        //if it gets set to somthing execute the code below set the vars below, otherwise skip it
        //didset is trigger when a post object (whether legit or nil) has been assigned
        didSet{
            
            if journalObject != nil {
                
                //may need to do something here at some point s
                
            }
        }
    }

    @IBAction func likeButtonClicked(_ sender: UIButton) {
        print("i was clicked")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            tapAnimation()
            journalObject?.isLiked = 1
            updateJournal()
        } else {
            journalObject?.isLiked = 0
            updateJournal()
        }
    }
    
    func updateJournal(){
        
        FBDatabase.EditJournalToDatabase(journalModel: journalObject!, closure: { (error) in
            if let error = error {
                print("Cell update error: ", error)
            }
        })
    }
    
    func tapAnimation(){
        
        if likeButton.isSelected == true
        {
            self.heartAnimationView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.heartAnimationView.isHidden = false
            
            
            //animation for 1 second, no delay
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { () -> Void in
                
                // during our animation change heartAnimationView to be 3X what it is on storyboard
                self.heartAnimationView.transform = CGAffineTransform(scaleX: 4, y: 4)
                
            }) { (success) -> Void in
                
                // when animation is complete set heartAnimationView to be hidden
                self.heartAnimationView.isHidden = true
            }
            
        }
    }        
}
