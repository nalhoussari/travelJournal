//
//  AddEntryViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol AddingEntryDelegate {
    func newEntryDetails(_ entry: JournalModel)
}

class AddEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePickerController = UIImagePickerController()
    var delegate: AddingEntryDelegate?
    var entry : JournalModel?
    
    var userID : String = ""
    
    var imagesStringArray = [String] ()

    @IBOutlet weak var newEntryTitle: UITextField!
    @IBOutlet weak var newEntryLocation: UILabel!
    @IBOutlet weak var newEntryDate: UIDatePicker!
    @IBOutlet weak var newPicturesTableView: UITableView!
    @IBOutlet weak var newEntryTextView: UITextView!
    
    
    var newEntryPhotos = [UIImage]()
    
    var firebaseDatabase = FBDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = (Auth.auth().currentUser?.uid)!   ///// current user
        self.newEntryTitle.delegate = self
        self.newEntryTextView.delegate = self as? UITextViewDelegate
        
        
        //for testing tableView only
//        imagesStringArray.append("image1")
//        imagesStringArray.append("image2")
//        imagesStringArray.append("image3")

        
        let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddEntryViewController.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    
    }
    
    //MARK: textFiled to dismiss keyboard with a return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
////        let urlString: String = imageURL.absoluteString!
////        imagesStringArray.append(urlString)
//            
//            newEntryPhotos.append(image)
//            
//        }
        
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            //let urlString: String = imageURL.absoluteString!
            imagesStringArray.append(imageURL.lastPathComponent!)
            
//            
//            let test5 = imageURL.lastPathComponent
//            print(test5 ?? "nothing")

        
//            let result =
//            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//            let asset = result.firstObject
//            let imageName = asset?.value(forKey: "filename")
        }else {
            print("!!!!")
        }
//        let imageName = imageURL.path!.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .userDomainMask, true).first as! String
//        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let compressedImage = UIImageJPEGRepresentation(selectedImage, 0.2)

        guard let newImage = UIImage(data: compressedImage!) else {
            fatalError("unable to convert compressed image")
        }
            //Add the selected image to the array of photos
        newEntryPhotos.append(newImage)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.newPicturesTableView.reloadData()
    }


    
    //MARK: - Action
    //select photo
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        //present(imagePickerController, animated: true, completion: nil)
//        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            imagePickerController.sourceType = .photoLibrary
//        } else {
//            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
//            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
//            imagePickerController.sourceType = .camera
//            imagePickerController.cameraDevice = .front
//            imagePickerController.cameraCaptureMode = .photo
//        }
        
        // Preset the pickerController on screen
        self.present(imagePickerController, animated: true, completion: nil)

        
    }
    

    //save button
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!){
        print("myRightSideBarButtonItemTapped")
        
        // pass the new entries in this initializer
        let newEntry = JournalModel(id: userID, title: newEntryTitle.text!, tripDescription: newEntryTextView.text, date: newEntryDate.date as Date, location: "location", latitude: 101, longitude: 100)
        
        newEntry.images = self.newEntryPhotos

        FBDatabase.SaveJournalToDatabase(journalModel: newEntry)
        self.delegate?.newEntryDetails(self.entry!)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Database of Photos TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesStringArray.count
    }

    //MARK: - Delegation of Photos TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? UITableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        let imageString = imagesStringArray[indexPath.row]
        cell.textLabel?.text = imageString
        cell.backgroundColor = UIColor.red
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Editing Rows of PhotosTableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            imagesStringArray.remove(at: indexPath.row)
            self.newPicturesTableView.reloadData()
        }
    }


}
