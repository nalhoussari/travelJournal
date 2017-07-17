//
//  FBDatabase.swift
//  travelJournal
//
//  Created by Kevin Cleathero on 2017-07-15.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class FBDatabase {

//MARK - Delete journal from database
    class func DeleteJournalFromDatabase(journalModel:JournalModel) {
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
      
        //delete record from database
        ref.child("journals").child(journalModel.fireBaseKey).removeValue { (error, ref) in
        //ref.child("journals").child(key).removeValue { (error, ref) in
            if error != nil{
                print("error \(error ?? "" as! Error)")
            }
        }
        
        
        //delete images from database storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()
        
        for image in journalModel.imageLocations {
        //for image in array{
            
            let imageRef = storeageRef.child(image)
            
            imageRef.delete { error in
                if let error = error {
                  print("error \(error)")
                } else {
                    // File deleted successfully
                }
            }
        } //for loop
        
        //delete from phone local directory
        for image in journalModel.imageLocations{
            
            let fileMngr = FileManager.default
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            
            let deletePath = documentsDirectory.appending("/\(image).png")
            
            do {
                try fileMngr.removeItem(atPath: deletePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        print("end of the line")
    }

//MARK - get ALL journals from database
    class func GetJournalsFromDatabase(closure: @escaping (_ journalArray:Array<JournalModel>) -> ()) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
    
        
        var journalDictionary = Dictionary<JournalModel, Array<UIImage>>()

        //var imagesArray = [UIImage]()
        var journalArray = [JournalModel]()
        
        //will need to use userID to fetch own records
        //let userID = Auth.auth().currentUser?.uid
        //ref.child("journal").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
        
        
        ref.child("journals").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
//            let journalRecords = snapshot.value as? NSDictionary
            
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot{
                let journalModel = JournalModel()
                
  
                //let username = journalRecord?["username"] as? String ?? ""
                
                let journal = child.value! as! [String:Any]
                //print(journal)
                //let date = NSDate(timeIntervalSince1970: journalRecord?["date"] as! TimeInterval)
                journalModel.fireBaseKey = child.key
                journalModel.id = journal["id"] as? Int ?? 0
                journalModel.date = journal["date"] as?  NSNumber ?? 0

                var imageLocations = Array<String>()
                journalModel.location = journal["location"] as? String ?? ""
                imageLocations = journal["imageLocations"] as? Array<String> ?? []
                journalModel.imageLocations = imageLocations
                journalModel.title = journal["title"] as? String ?? ""
                journalModel.tripDescription = journal["tripDescription"] as? String ?? ""
                journalModel.latitude = journal["latitude"] as? NSNumber ?? 0
                journalModel.longitude = journal["latitude"] as? NSNumber ?? 0
                
                OperationQueue.main.addOperation {
                    
                    for image in imageLocations{
      
                        let journalImages = self.GetJournalImages(imageLocation: image)
                        journalModel.images.append(journalImages)
                        
                    }
                    
                    journalArray.append(journalModel)
                    closure(journalArray)
   
                    journalArray.removeAll()
                    journalDictionary.removeAll()

                }
            
         } //while loop
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
//MARK - get ALL journal images from database
    class func GetJournalImages(imageLocation:String) -> UIImage {
        //storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filename = "/\(imageLocation).png"
        let filePath = "file:\(documentsDirectory)\(filename)"
        var image = UIImage()
            
        let createPath = documentsDirectory.appending("/images")
        
        //create "images" directory under documents if it doesn't exist
        do {
            try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let localURL = URL(string: filePath)!
    
        let dbRef = storeageRef.child(imageLocation)
      
           dbRef.write(toFile: localURL) { (url, error) in
            if let error = error{
                //uh-oh an error happened
                print("the errors is: \(error)")
            } else {
                
                    let imagePath = url?.absoluteURL
                    image = UIImage(contentsOfFile: (imagePath?.path)!)!
                }
            } 

        return image
        
    }

    
//MARK - Save journal to database
    class func SaveJournalToDatabase(journalModel:JournalModel){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()
    
        var imageReferences: Array<String> = []
    
        for image in journalModel.images{
            
            let uuid = UUID()
            let newImageName = uuid.uuidString
        
            let data = UIImagePNGRepresentation(image)
            
            let imageRef = storeageRef.child("images/\(newImageName)")
        
            imageReferences.append(imageRef.fullPath)
            
            _ = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                if let error = error{
                    print("error is \(error)")
                }
                else {
                    print("inside else - upload Successful")
                }
            })
        }
        
        journalModel.imageLocations = imageReferences
    
        let refPhotos = ref.child(byAppendingPath: "journals")
        let refBase54 = refPhotos.childByAutoId()
        refBase54.setValue(journalModel.journalDictionary)

    } //function end
    
}