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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func tapAnimation(){
        
        
        //Done: Check if the post is already liked, if it is then do not run animation code
        //if likeButton.isSelected != true
        //{
        self.heartAnimationView.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.heartAnimationView.isHidden = false
        
        
        //animation for 1 second, no delay
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { () -> Void in
            
            // during our animation change heartAnimationView to be 3X what it is on storyboard
            self.heartAnimationView.transform = CGAffineTransform(scaleX: 3, y: 3)
            
        }) { (success) -> Void in
            
            // when animation is complete set heartAnimationView to be hidden
            self.heartAnimationView.isHidden = true
        }
        
        // likeButtonClicked(likeButton)
        //}
        
    }
    
}
