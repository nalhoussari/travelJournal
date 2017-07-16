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
    


    //class func GetJournalFromDatabase() -> (Dictionary<JournalModel, Array<UIImage>>) {

    class func GetJournalFromDatabase(closure: @escaping (_ diction:Dictionary<JournalModel, Array<UIImage>>) -> ()) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
    
        
        var journalDictionary = Dictionary<JournalModel, Array<UIImage>>()
        let journalModel = JournalModel()
        var imagesArray = [UIImage]()
        
        //will need to use userID to fetch own records
        //let userID = Auth.auth().currentUser?.uid
        //ref.child("journal").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
        
        
        ref.child("journals").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //let journalRecords = snapshot.value as? NSDictionary
            
            //NSEnumerator *enumerator = [snapshot children];
            let enumerator = snapshot.children
            //var child = DataSnapshot()
            //while(child = enumerator.nextObject() as! DataSnapshot){
            while let child = enumerator.nextObject() as? DataSnapshot{
            
                //let username = journalRecord?["username"] as? String ?? ""
                
                let journal = child.value! as! [String:Any]
                print(journal)
                //let date = NSDate(timeIntervalSince1970: journalRecord?["date"] as! TimeInterval)
                journalModel.id = journal["id"] as? Int ?? 0 // ["id"] as? Int ?? 0
                journalModel.date = journal["date"] as?  NSNumber ?? 0
                //journalModel.imageLocations = journalRecord?["imageLocations"] as? Array ?? []
                var imageLocations = Array<String>()
                journalModel.location = journal["location"] as? String ?? ""
                imageLocations = journal["imageLocations"] as? Array<String> ?? []
                journalModel.title = journal["title"] as? String ?? ""
                journalModel.tripDescription = journal["tripDescription"] as? String ?? ""
                journalModel.latitude = journal["latitude"] as? NSNumber ?? 0
                journalModel.longitude = journal["latitude"] as? NSNumber ?? 0
                
                
                //let journalImages = GetJournalImages(<#T##FBDatabase#>)
                //var count:Int = 0
                
           
                
                OperationQueue.main.addOperation {
                    for image in imageLocations{
      
                        
                        let journalImages = self.GetJournalImages(imageLocation: image)
                        
//                        self.GetJournalImages(imageLocation: image, closure: { (image) in
//                              imagesArray.append(image)
//                            print("IN FOR CLosurE BLOCK items in imagesArray... \(imagesArray.count)")
//                        })
                        
                        //self.GetJournalImages(imageLocation: image as! String, closure: { (image) in
                            //imagesArray.append(image)
                        //})
                        //let journalImages = self.GetJournalImages(imageLocations: imageLocations as! Array<String>)
                        imagesArray.append(journalImages)
                        
                        //print("IN FOR LOOP items in imagesArray...")
                        print("IN FOR LOOP items in imagesArray... \(imagesArray.count)")
                    }
                    journalDictionary.updateValue(imagesArray, forKey: journalModel)
                    imagesArray.removeAll()
                    closure(journalDictionary)
                 
                }
                
                //print("OUT OF  FOR LOOP items in imagesArray...")
                print("OUT OF  FOR LOOP items in imagesArray...\(imagesArray.count)")
                
                print(journalModel)
                
//                journalDictionary.updateValue(imagesArray, forKey: journalModel)
//                
//                closure(journalDictionary)
            
         } //while loop
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //return (journalDictionary)
    }
    

    //class func GetJournalImages(imageLocations:Array<String>) -> Array<UIImage> {
    //class func GetJournalImages(imageLocation:String) -> UIImage {
    
    //class func GetJournalImages(imageLocation:String, closure: @escaping (_ image:UIImage) -> ()) {
    class func GetJournalImages(imageLocation:String) -> UIImage {
        //storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()
        //let dbRef = storeageRef.child("images/94AB26D7-EC31-445B-A4C1-B856D68A77E5")
        
        //var imageArray = Array<UIImage>()
        
        
        //let dbRef = database.reference().child("myFiles")
        
        //dbRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
        // Get download URL from snapshot
        //let downloadURL = snapshot.value() as! String
        // Create a storage reference from the URL
        //let storeRef = storage.referenceFromURL(downloadURL)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        
       //dbRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
        
        //for image in imageLocations{
        
         
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filename = "/\(imageLocation).png"
        let filePath = "file:\(documentsDirectory)\(filename)"
        var image = UIImage()
            
        let createPath = documentsDirectory.appending("images")
        
        //create "images" directory under documents
        do {
            try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
            
        //let filePath = "file:\(documentsDirectory)/"
        //let storagePath = UserDefaults.standard.object(forKey: "storagePath") as! String
            
            
        // Create local filesystem URL
       // let directoryPath =  NSHomeDirectory().appending("/Dcouments/\(image)")
        
        //let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let localURL = documentsURL.appendingPathComponent("Images")
        
        let localURL = URL(string: filePath)!
        print(localURL)
        
    
        
        let dbRef = storeageRef.child(imageLocation)
      
//OperationQueue.main.addOperation {
         //OperationQueue.main.addOperation {
           dbRef.write(toFile: localURL) { (url, error) in
            if let error = error{
                //uh-oh an error happened
                print("the errors is: \(error)")
            } else {
                    
                    //let filepath = directoryPath.appending(image)
                    //let pic = UIImage(data: data!)
                    let imagePath = url?.absoluteURL
                    //let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(image)
                    image = UIImage(contentsOfFile: (imagePath?.path)!)!
                    //closure(image)
                    //imageArray.append(image!)
                    //print(imageArray.count)
                }
            } 
//}
            //dbRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//            if error == nil{
//                // Create a UIImage, add it to the array
//                let pic = UIImage(data: data!)
//                imageArray.append(pic!)
//            } else {
//                print("Error retrieving images")
//            }
        
        //}
        print("This IMAGE IS.......")
        print(image)
        return image
        
    }

    
    
   class func SaveJournalToDatabase(journalModel:JournalModel, images:Array<UIImage>){
    
    
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //storage
        var storeageRef: StorageReference!
        storeageRef = Storage.storage().reference()
    
        
        var imageReferences: Array<String> = []
        
//        var imageDict = [String:UIImage]()
        
        //for imageName in imageNames {
        for image in images {
            
            let uuid = UUID()
            let newImageName = uuid.uuidString
            
            //imageDict[newImageName] = image
            
            let data = UIImagePNGRepresentation(image)
            
            
            //let imageRef = storeageRef.child("images/\(uuid.uuidString)")
            let imageRef = storeageRef.child("images/\(newImageName)")
            
            //            let data = UIImagePNGRepresentation(UIImage(named: imageName)!)
            //            //let imageRef = storeageRef.child("images/\(uuid.uuidString)")
            //            let imageRef = storeageRef.child("images/\(uuid.uuidString)")
            imageReferences.append(imageRef.fullPath)
            
            _ = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                if let error = error{
                    print("error is \(error)")
                }
                else {
                    print("inside else - upload Successful")
                    //let downloadURL = metadata!.downloadURL()
                    
                }
                
            })
            
        }
        
    
        journalModel.imageLocations = imageReferences
    
    
        //[[[self.FirDBRef child:@"users"] childByAutoId] setValue:userDict];
    //let quoteString = ["base64": base64String]
        let refPhotos = ref.child(byAppendingPath: "journals")
        let refBase54 = refPhotos.childByAutoId()
        refBase54.setValue(journalModel.journalDictionary)
    
    //    ref.child("journal").setValue(journalModel.journalDictionary)
    
    } //function end
    
}
