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
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var heartAnimationView: UIImageView!

    var entry : JournalModel?
    var imagesArray = [UIImage]()
    var imageCounter : Int = 0
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           self.gettingImages { (error) in
            if let error = error{
                print("the errors is: \(error)")
            } else {
                OperationQueue.main.addOperation {
                    self.configureView()
                }
            }
        }
    
        self.detailTextView.isEditable = false
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }

    
    func setJournalItem(_ journalItem: JournalModel){
        self.entry = journalItem
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                 moveImageRight()
            case UISwipeGestureRecognizerDirection.left:
                 moveImageLeft()
            default:
                break
            }
        }
    }
    
    func gettingImages(closure: @escaping (_ error: Error?) -> ()) {
        
        if (self.entry?.localImagePath.count)! <= 1 {
            if (self.entry?.imageLocations.count)! > 0 {
                
                for imageTemp in (self.entry?.imageLocations)! {
                    
                    FBDatabase.GetJournalImages(imageLocation:
                    imageTemp) { (image, localImagePath, error) in
                        if let error = error{
                            //uh-oh an error happened
                            print("the errors is: \(error)")
                        } else {
                        OperationQueue.main.addOperation {
                            self.imagesArray.append(image)
                            self.counter += 1
                            self.entry?.localImagePath.append(localImagePath)
                            }
                        }
                        closure(error)
                    }
                    print (counter)
                }
            } else {
                let image = UIImage(named: "default.png")
                self.imagesArray.append(image!)
            }
        } else {
            for imagePathTemp in (self.entry?.localImagePath)! {
                let fp = imagePathTemp
                let imageURL = URL(fileURLWithPath: fp)
                let image = UIImage(contentsOfFile: imageURL.path)
                self.imagesArray.append(image!)
            }
        }
    }
    
    func moveImageLeft(){
        imageCounter -= 1
        self.detailImageView.image = self.imagesArray[self.imagesCounter()]
    }
    
    func moveImageRight(){
        imageCounter += 1
        self.detailImageView.image = self.imagesArray[self.imagesCounter()]
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton){
        moveImageLeft()
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        moveImageRight()
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
        
        if entry?.isLiked == 1 {
            likeButton.isSelected = true
        }
        
        for imagePathTemp in (entry?.localImagePath)! {
            let fp = imagePathTemp
            let imageURL = URL(fileURLWithPath: fp)
            let image = UIImage(contentsOfFile: imageURL.path)
            self.imagesArray.append(image!)
        }
        if self.imagesArray.count > 0 {
            detailImageView.image = self.imagesArray[0]
        }
    }
    
    @IBAction func doubleTappedSelfie(_ sender: UITapGestureRecognizer) {
        tapAnimation()
    }
    
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        

        if sender.isSelected {
            entry?.isLiked = 1
            updateJournal()
        } else {
            entry?.isLiked = 0
            updateJournal()
        }
    }
    
    func updateJournal(){
        
        FBDatabase.EditJournalToDatabase(journalModel: entry!, closure: { (error) in
    
            if let error = error {
                let alert = UIAlertController(title: "Error Updating", message: "\(error)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    print("OK")
                })
                
                self.present(alert, animated: true)
            }
            
        })
    }
    
    func tapAnimation(){

       if likeButton.isSelected != true
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
            
            likeButtonClicked(likeButton)
         }
       }
    }
  

