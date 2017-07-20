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
    var imagesArray = [UIImage]()
    var imageCounter : Int = 0
    var counter = 0
    
    
    func gettingImages() {
        if (entry?.localImagePath.count)! <= 1 {
            if (entry?.imageLocations.count)! > 0 {
                for imageTemp in (entry?.imageLocations)! {
                    FBDatabase.GetJournalImages(imageLocation:
                    imageTemp) { (image, localImagePath) in
                        self.imagesArray.append(image)
                        self.counter += 1
                        self.entry?.localImagePath.append(localImagePath)
                    }
                    print (counter)
                }
            } else {
                let image = UIImage(named: "default.png")
                self.imagesArray.append(image!)
            }
        } else {
            for imagePathTemp in (entry?.localImagePath)! {
                let fp = imagePathTemp
                let imageURL = URL(fileURLWithPath: fp)
                let image = UIImage(contentsOfFile: imageURL.path)
                self.imagesArray.append(image!)
            }
        }
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton){
        imageCounter -= 1
        detailImageView.image = self.imagesArray[self.imagesCounter()]
        
        
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        imageCounter += 1
        //        self.imagesCounter()
        detailImageView.image = self.imagesArray[self.imagesCounter()]
    }
    
    func imagesCounter()->Int{
        
        if(imageCounter == self.imagesArray.count)
        {
            imageCounter = 0
        }
            
        else if (imageCounter < 0)
        {
            imageCounter = (self.imagesArray.count)-1
        }
        return imageCounter
    }
    
    func configureView(){
        
        //converting NSNumber to string
        let dateObj = entry?.date
        let date = (Date(timeIntervalSince1970: TimeInterval(dateObj!)))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let stringDate = dateFormatter.string(from: date)
        
        detailTitleLabel.text = entry?.title
        detailLocationLabel.text = entry?.location
        detailDateLabel.text = stringDate
        detailTextView.text = entry?.tripDescription
        for imagePathTemp in (entry?.localImagePath)! {
            let fp = imagePathTemp
            let imageURL = URL(fileURLWithPath: fp)
            let image = UIImage(contentsOfFile: imageURL.path)
            self.imagesArray.append(image!)
        }
        detailImageView.image = self.imagesArray[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gettingImages()
        self.configureView()
        self.detailTextView.isEditable = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
