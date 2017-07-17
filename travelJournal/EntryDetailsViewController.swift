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
    
//    var imageArray = [UIImage] ()
    var entry : JournalModel?
    
    var imageCounter : Int = 0
    
    
    @IBAction func leftButtonTapped(_ sender: UIButton){
        imageCounter -= 1
        detailImageView.image = entry?.images[imageCounter]
        
        
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        imageCounter += 1
        detailImageView.image = entry?.images[imageCounter]
    }
    
    func imagesCounter()->Int{
        
        if(imageCounter == entry?.images.count)
        {
            imageCounter = 0
            
        }
        
        else if (imageCounter < 0)
        {
            imageCounter = (entry?.images.count)!-1
        }
        
        return imageCounter
    }
    func configureView(){
        
        //converting date to string
        
        let dateobj = entry?.date
        let dateStr = "\(dateobj ?? NSDate())"
        
        detailTitleLabel.text = entry?.title
        detailLocationLabel.text = entry?.location
        detailDateLabel.text = dateStr
        detailTextView.text = entry?.description
        detailImageView.image = entry?.images[imageCounter]
        
        
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
