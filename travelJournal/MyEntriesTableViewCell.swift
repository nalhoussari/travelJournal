//
//  MyEntriesTableViewCell.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class MyEntriesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var myEntriesLabelTitle: UILabel!
    @IBOutlet weak var myEntriesLabelDescription: UILabel!
    @IBOutlet weak var myEntriesImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
  
    @IBOutlet var heartAnimationView: UIImageView!
    
    @IBOutlet var likebutton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
