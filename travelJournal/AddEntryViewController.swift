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
        userID = (Auth.auth().currentUser?.email)!   ///// current user
        self.newEntryTitle.delegate = self
        self.newEntryTextView.delegate = self as? UITextViewDelegate

        let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AllEntriesTableViewController.myRightSideBarButtonItemTapped(_:)))
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
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            let urlString: String = imageURL.absoluteString!
            imagesStringArray.append(urlString)
            
            print(imageURL)
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
        // Add the selected image to the array of photos
        newEntryPhotos.append(selectedImage)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }


    
    //MARK: - Action
    //select photo
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
        //getting the image URL
    }
    

    //save button
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!){
        print("myRightSideBarButtonItemTapped")
        
        // pass the new entries in this initializer
        let newEntry = JournalModel(id: userID, title: newEntryTitle.text!, tripDescription: newEntryTextView.text, date: newEntryDate.date, location: "location", latitude: 101, longitude: 100)

        
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
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
//        cell.textLabel?.text = imagesStringArray
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
            newEntryPhotos.remove(at: indexPath.row)
            self.newPicturesTableView.reloadData()
        }
    }


}
