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
    
        //var journalDictionary = Dictionary<JournalModel, Array<UIImage>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FBDatabase.DeleteJournalFromDatabase(journalModel: jm)
        
        //self.populateDBWithTestData()
        
//        FBDatabase.GetJournalsFromDatabase { (journalArray) in
//            
//            for journal in journalArray{
//                print("\n")
//                print("************************************")
//                print(journal.title)
//                print(journal.date)
//                print(journal.id)
//                print(journal.imageLocations)
//                print(journal.latitude)
//                print(journal.longitude)
//                print(journal.tripDescription)
//                print(journal.date)
//                
//                for image in journal.images{
//                    print(image)
//                }
//                print("************************************")
//            }
//            
//        }
        
//        FBDatabase.GetJournalsFromDatabase { (dictionary) in
//          print("\n")
//
//            self.journalDictionary = dictionary
// 
//            print("dictionary count: \(dictionary.count)")
//            for (key,value) in dictionary{
//                let jm = key as JournalModel
//                let imageArray = value
//            
//                
//                print("***********************************")
//                print("array count: \(imageArray.count)")
//                print(jm.date)
//                print(jm.id)
//                print(jm.imageLocations)
//                print(jm.latitude)
//                print(jm.longitude)
//                print(jm.title)
//                print(jm.tripDescription)
//                print(jm.date)
//                
//                print(imageArray.count)
//   
//                
//                print("items in ARRAY for FL: \(imageArray.count)")
//                for image in imageArray{
//                    print("in image array loop")
//                    print(image)
//                }
//                print("***********************************")
//      
//            }
//
//        }
        
    }
    
    
    func populateDBWithTestData(){
        
        var images: Array<UIImage> = []
        images.append(UIImage(named: "filledStar.png")!)
        images.append(UIImage(named: "meal1.png")!)
        images.append(UIImage(named: "meal2.png")!)
        images.append(UIImage(named: "meal3.png")!)
        
        let todaysDate = NSDate()
        
        let journalModel = JournalModel(id: 123, title: "FIRST RECORD", tripDescription: "Lorem ipsum dolor sit amet, ludus dicant lobortis et eos", date: todaysDate, location: "123 somewhere street", latitude: 23.3333, longitude: -123.12333)
        
        journalModel.images = images
        FBDatabase.SaveJournalToDatabase(journalModel:journalModel)
        
        
        var images2: Array<UIImage> = []
        images2.append(UIImage(named: "sim1.png")!)
        images2.append(UIImage(named: "sim2.png")!)
        images2.append(UIImage(named: "sim3.png")!)
        images2.append(UIImage(named: "sim4.png")!)
        
        let jm = JournalModel(id: 456, title: "SECOND RECORD", tripDescription: "this is a long test text message that is here for emergencey purposes only, don not be alarmed ", date: todaysDate, location: "456 elsewhere avenue", latitude: 18.4333, longitude: -118.83333)
        
        jm.images = images2
        
        FBDatabase.SaveJournalToDatabase(journalModel:jm)
        
        
        let images3: Array<UIImage> = []
        //        images3.append(UIImage(named: "sim1.png")!)
        //        images3.append(UIImage(named: "sim2.png")!)
        //        images3.append(UIImage(named: "sim3.png")!)
        //        images3.append(UIImage(named: "sim4.png")!)
        
        let jm3 = JournalModel(id: 456, title: "Third RECORD", tripDescription: "x0xb0x TB-303 TR-909 TR-808 SH-101 MODCAN MOudlAR SYSTEM-100M", date: todaysDate, location: "789 downthere ally", latitude: 9.22222, longitude: -18.111111)
        
        FBDatabase.SaveJournalToDatabase(journalModel:jm3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {  super.didReceiveMemoryWarning()}
}
