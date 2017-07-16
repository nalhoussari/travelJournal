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
    
        let journalModel = JournalModel(id: 123, title: "New title here", tripDescription: "Lorem ipsum dolor sit amet, ludus dicant lobortis et eos", date: todaysDate, location: "123 somewhere street", latitude: 23.3333, longitude: -123.12333)
        
        
        //FBDatabase.SaveJournalToDatabase(journalModel:journalModel, images:images)
        
  
        //let journalDictionary = FBDatabase.GetJournalFromDatabase()
        
        FBDatabase.GetJournalFromDatabase { (dictionary) in
          print(dictionary)
            
            for (key,value) in dictionary{
                let jm = key as JournalModel
                let imageArray = value
                
                print(jm.date)
                print(jm.id)
                print(jm.imageLocations)
                print(jm.latitude)
                print(jm.longitude)
                print(jm.title)
                print(jm.tripDescription)
                print(jm.date)
                
                for image in imageArray{
                    print(image)
                }
                
            }
        
        }
        
//        let fuck = FBDatabase.GetJournalFromDatabase { () -> (Dictionary<JournalModel, Array<UIImage>>) in
//            
//            return
//        }
        
//        let journalDictionary = FBDatabase.GetJournalFromDatabase(closure:  { () -> (Dictionary<JournalModel, Array<UIImage>>) in
//            
//            return
//        })
//        
        
        //print(journalDictionary)
        
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        
//        //storage
//        var storeageRef: StorageReference!
//        storeageRef = Storage.storage().reference()
//
//        
//        var images: Array<UIImage> = []
//        images.append(UIImage(named: "filledStar.png")!)
//        images.append(UIImage(named: "meal1.png")!)
//        images.append(UIImage(named: "meal2.png")!)
//        images.append(UIImage(named: "meal3.png")!)
//        
//        
// 
////        var imageNames: Array<String> = []
////        imageNames.append("meal1.png")
////        imageNames.append("meal2.png")
////        imageNames.append("meal3.png")
////        imageNames.append("filledStar.png")
//        
//        
//        var imageReferences: Array<String> = []
//        
//        var imageDict = [String:UIImage]()
//        
//        //for imageName in imageNames {
//        for image in images {
//            
//            let uuid = UUID()
//            let newImageName = uuid.uuidString
//            
//            //imageDict[newImageName] = image
//            
//            let data = UIImagePNGRepresentation(image)
//        
//            
//            //let imageRef = storeageRef.child("images/\(uuid.uuidString)")
//            let imageRef = storeageRef.child("images/\(newImageName)")
//            
////            let data = UIImagePNGRepresentation(UIImage(named: imageName)!)
////            //let imageRef = storeageRef.child("images/\(uuid.uuidString)")
////            let imageRef = storeageRef.child("images/\(uuid.uuidString)")
//            imageReferences.append(imageRef.fullPath)
//            
//            let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
//                if let error = error{
//                    print("error is \(error)")
//                }
//                else {
//                    print("inside else")
//                    let downloadURL = metadata!.downloadURL()
//                }
// 
//            })
//            
//        }
//   
//        let todaysDate = NSDate()
//        
//        let journalModel = JournalModel(id:123, title:"New title here", tripDescription:"Lorem ipsum dolor sit amet, ludus dicant lobortis et eos", date:todaysDate, imageLocations: imageReferences, location:"123 somewhere street")
//
//    
//        ref.child("journal").setValue(journalModel.journalDictionary)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {  super.didReceiveMemoryWarning()}
}
