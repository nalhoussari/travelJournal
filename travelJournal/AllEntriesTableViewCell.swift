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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
