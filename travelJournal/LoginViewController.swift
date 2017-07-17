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
    
<<<<<<< HEAD
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
=======
        var journalDictionary = Dictionary<JournalModel, Array<UIImage>>()
    
>>>>>>> firebaseactions
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let jm = JournalModel()
        FBDatabase.DeleteJournalFromDatabase(journalModel: jm)
        
        //self.populateDBWithTestData()
        
        FBDatabase.GetJournalsFromDatabase { (dictionary) in
          print("\n")

            self.journalDictionary = dictionary
 
            print("dictionary count: \(dictionary.count)")
            for (key,value) in dictionary{
                let jm = key as JournalModel
                let imageArray = value
            
                
                print("***********************************")
                print("array count: \(imageArray.count)")
                print(jm.date)
                print(jm.id)
                print(jm.imageLocations)
                print(jm.latitude)
                print(jm.longitude)
                print(jm.title)
                print(jm.tripDescription)
                print(jm.date)
                
                print(imageArray.count)
   
                
                print("items in ARRAY for FL: \(imageArray.count)")
                for image in imageArray{
                    print("in image array loop")
                    print(image)
                }
                print("***********************************")
      
            }

        }
        
    }
    
    
    func populateDBWithTestData(){
        
        var images: Array<UIImage> = []
        images.append(UIImage(named: "filledStar.png")!)
        images.append(UIImage(named: "meal1.png")!)
        images.append(UIImage(named: "meal2.png")!)
        images.append(UIImage(named: "meal3.png")!)
        
        let todaysDate = NSDate()
        
        let journalModel = JournalModel(id: 123, title: "FIRST RECORD", tripDescription: "Lorem ipsum dolor sit amet, ludus dicant lobortis et eos", date: todaysDate, location: "123 somewhere street", latitude: 23.3333, longitude: -123.12333)
        
        
        FBDatabase.SaveJournalToDatabase(journalModel:journalModel, images:images)
        
        
        var images2: Array<UIImage> = []
        images2.append(UIImage(named: "sim1.png")!)
        images2.append(UIImage(named: "sim2.png")!)
        images2.append(UIImage(named: "sim3.png")!)
        images2.append(UIImage(named: "sim4.png")!)
        
        let jm = JournalModel(id: 456, title: "SECOND RECORD", tripDescription: "this is a long test text message that is here for emergencey purposes only, don not be alarmed ", date: todaysDate, location: "456 elsewhere avenue", latitude: 18.4333, longitude: -118.83333)
        
        FBDatabase.SaveJournalToDatabase(journalModel:jm, images:images2)
        
        
        let images3: Array<UIImage> = []
        //        images3.append(UIImage(named: "sim1.png")!)
        //        images3.append(UIImage(named: "sim2.png")!)
        //        images3.append(UIImage(named: "sim3.png")!)
        //        images3.append(UIImage(named: "sim4.png")!)
        
        let jm3 = JournalModel(id: 456, title: "Third RECORD", tripDescription: "x0xb0x TB-303 TR-909 TR-808 SH-101 MODCAN MOudlAR SYSTEM-100M", date: todaysDate, location: "789 downthere ally", latitude: 9.22222, longitude: -18.111111)
        
        FBDatabase.SaveJournalToDatabase(journalModel:jm3, images:images3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {  super.didReceiveMemoryWarning()}
}
