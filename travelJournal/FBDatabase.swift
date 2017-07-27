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
    class func GetJournalsFromDatabase(closure: @escaping (_ journalArray:Array<JournalModel>?, _ error: Error?) -> ()) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var journalArray = [JournalModel]()

        ref.child("journals").observeSingleEvent(of: .value, with: { (snapshot) in
        
            let enumerator = snapshot.children
            var journalDictionary = Dictionary<JournalModel, Array<UIImage>>()
            while let child = enumerator.nextObject() as? DataSnapshot{
                let journalModel = JournalModel()
                
                
                let journal = child.value! as! [String:Any]
                //let date = NSDate(timeIntervalSince1970: journalRecord?["date"] as! TimeInterval)
                journalModel.fireBaseKey = child.key
                journalModel.id = journal["id"] as? String ?? ""
                journalModel.date = journal["date"] as?  NSNumber ?? 0
                
                var imageLocations = Array<String>()
                journalModel.location = journal["location"] as? String ?? ""
                imageLocations = journal["imageLocations"] as? Array<String> ?? []
                journalModel.imageLocations = imageLocations
                journalModel.title = journal["title"] as? String ?? ""
                journalModel.tripDescription = journal["tripDescription"] as? String ?? ""
                journalModel.latitude = journal["latitude"] as? NSNumber ?? 0
                journalModel.longitude = journal["longitude"] as? NSNumber ?? 0
                journalModel.isLiked = journal["liked"] as? NSNumber ?? 0
                
                journalArray.append(journalModel)
                journalDictionary.removeAll()
                
            } //while loop
            
            //needed here because closure deals with UI at the call source
            OperationQueue.main.addOperation {

                closure(journalArray, nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            closure(nil, error)
        }
        
    }
    
    //MARK - get ALL journal images from database
    class func GetJournalImages(imageLocation:String, closure: @escaping (_ image:UIImage, _ localImagePath:String, _ error: Error?) -> ()) {
    
        
            //storage
            var storeageRef: StorageReference!
            storeageRef = Storage.storage().reference()
        
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filename = "/\(imageLocation).png"
            let filePath = "file:\(documentsDirectory)\(filename)"
            var image = UIImage()
            let localImagePath = "\(documentsDirectory)\(filename)"
        
        
        
            let createPath = documentsDirectory.appending("/images")
            
            //create "images" directory under documents if it doesn't exist
            do {
                try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            
            let localURL = URL(string: filePath)!
        
            let dbRef = storeageRef.child(imageLocation)
        
            print("dbRef: ", dbRef)
        
            dbRef.write(toFile: localURL) { (url, error) in
                if let error = error{
                    //uh-oh an error happened
                    print("the errors is: \(error)")
                } else {
                    
                    if url?.absoluteURL != nil {
                        let imagePath = url?.absoluteURL
                         if imagePath?.path != nil {
                            image = UIImage(contentsOfFile: (imagePath?.path)!)!
                        }
                    }
                }
                closure(image, localImagePath, error)
            }

    }
    
    
    //MARK - Save journal to database
    class func SaveJournalToDatabase(journalModel:JournalModel, closure: @escaping (_ error: Error?) -> ()){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()
        
        var imageReferences: Array<String> = []
        
        for imgData in journalModel.imageData{
            
            let uuid = UUID()
            let newImageName = uuid.uuidString
        
            let imageRef = storeageRef.child("images/\(newImageName)")
            
            imageReferences.append(imageRef.fullPath)
            
            _ = imageRef.putData(imgData, metadata: nil, completion: { (metadata, error) in
                if let error = error{
                    print("error is \(error)")
                }
                else {
                    print("inside else - upload Successful")
                }
                
                //trigger everytime but because its an optional if its nil it's ignored in the UI side
                //if error alert is shown
                closure(error)
            })
        }

        journalModel.imageLocations = imageReferences
        
        let refPhotos = ref.child(byAppendingPath: "journals")
        let refBase54 = refPhotos.childByAutoId()
        refBase54.setValue(journalModel.journalDictionary)
        
    } //function end
    
    //MARK - Save journal to database
    class func EditJournalToDatabase(journalModel:JournalModel, closure: @escaping (_ error: Error?) -> ()){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userRef = ref.child("journals").child(journalModel.fireBaseKey)
        
        userRef.updateChildValues(["liked": journalModel.isLiked]) { (error, dbRef) in
            closure(error)
        }
    }
}
