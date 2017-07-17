//
//  EntryDetailsViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class EntryDetailsViewController: UIViewController {
   
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var entry : JournalModel?
    
    func configureView(){
        detailTitleLabel.text = entry?.title
        detailLocationLabel.text = entry?.location
//        detailDateLabel.text = entry?.date
        detailTextView.text = entry?.description
//        detailImageView = entry?.photosUIImageArray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.detailTextView.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
