//
//  LoginViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var images: Array<UIImage> = []
        images.append(UIImage(named: "filledStar.png")!)
        images.append(UIImage(named: "meal1.png")!)
        images.append(UIImage(named: "meal2.png")!)
        images.append(UIImage(named: "meal3.png")!)
        
        let todaysDate = NSDate()
    
        let journalModel = JournalModel(id: 123, title: "FIRST RECORD", tripDescription: "Lorem ipsum dolor sit amet, ludus dicant lobortis et eos", date: todaysDate, location: "123 somewhere street", latitude: 23.3333, longitude: -123.12333)
        
        
        //FBDatabase.SaveJournalToDatabase(journalModel:journalModel, images:images)
        
        
        var images2: Array<UIImage> = []
        images2.append(UIImage(named: "sim1.png")!)
        images2.append(UIImage(named: "sim2.png")!)
        images2.append(UIImage(named: "sim3.png")!)
        images2.append(UIImage(named: "sim4.png")!)
        
        let jm = JournalModel(id: 456, title: "SECOND RECORD", tripDescription: "GOONEY FUCKING GOO GOO GOONEY FUCKING GOO GOO GOONEY FUCKING GOO GOO ", date: todaysDate, location: "456 elsewhere avenue", latitude: 18.4333, longitude: -118.83333)
        
        //FBDatabase.SaveJournalToDatabase(journalModel:jm, images:images2)
        
        //let journalDictionary = FBDatabase.GetJournalFromDatabase()
        
        FBDatabase.GetJournalFromDatabase { (dictionary) in
          print(dictionary)
            
            for (key,value) in dictionary{
                let jm = key as JournalModel
                let imageArray = value
                
                print("***********************************")
                print(imageArray.count)
                print(jm.date)
                print(jm.id)
                print(jm.imageLocations)
                print(jm.latitude)
                print(jm.longitude)
                print(jm.title)
                print(jm.tripDescription)
                print(jm.date)
                
                print(imageArray.count)
                print("***********************************")
                
                print("items in ARRAY for FL: \(imageArray.count)")
                for image in imageArray{
                    print("FUCKY LARGE")
                    print(image)
                }
                
            }
        
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {  super.didReceiveMemoryWarning()}
}
