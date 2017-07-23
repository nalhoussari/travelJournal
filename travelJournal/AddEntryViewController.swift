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
import CoreLocation

protocol AddingEntryDelegate {
    func newEntryDetails(_ entry: JournalModel)
}

class AddEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePickerController = UIImagePickerController()
    var delegate: AddingEntryDelegate?
    var entry : JournalModel?
    
    var userID : String = ""
    
    var imagesStringArray = [String] ()

    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newEntryLocation: UITextField!
    @IBOutlet weak var newEntryTitle: UITextField!
    @IBOutlet weak var newEntryDate: UIDatePicker!
    @IBOutlet weak var newPicturesTableView: UITableView!
    @IBOutlet weak var newEntryTextView: UITextView!
    
    var lat = NSNumber()
    var long = NSNumber()
    
    var newEntryPhotos = [UIImage]()
    var imageData = [Data]()
    let spinner = UIActivityIndicatorView()
    var firebaseDatabase = FBDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = (Auth.auth().currentUser?.email)!   ///// current user
        self.newEntryTitle.delegate = self
        self.newEntryTextView.delegate = self as? UITextViewDelegate
        
        
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
        

        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            //let urlString: String = imageURL.absoluteString!
            imagesStringArray.append(imageURL.lastPathComponent!)
            
        }else {
            print("!!!!")
        }
//        let imageName = imageURL.path!.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .userDomainMask, true).first as! String
//        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let compressedImage = UIImageJPEGRepresentation(selectedImage, 0.0)
        imageData.append(compressedImage!)

        newEntryPhotos.append(selectedImage)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.newPicturesTableView.reloadData()
    }


    
    //MARK: - Action
    //select photo
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
    convertLocationToCoordinates()    
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
    // MARK: - Geocoding
    @IBAction func tapOutsideTextField(_ sender: Any) {
        convertLocationToCoordinates()
    }
    lazy var geocoder = CLGeocoder()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func convertLocationToCoordinates()
    {
        guard let userLocation = newEntryLocation.text else { return }
        
        // Geocode Address String
        let address = "\(userLocation)"
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {print("Unable to Forward Geocode Address (\(error))")}
        else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                self.lat = coordinate.latitude as NSNumber;()
                self.long = coordinate.longitude as NSNumber;()
                
            } else {}
        }
    }

    //save button
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!){
        print("myRightSideBarButtonItemTapped")
    
        self.view.addSubview(self.spinner)
        self.spinner.center = (self.view.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        
        // pass the new entries in this initializer
        let newEntry = JournalModel(id: userID, title: newEntryTitle.text!, tripDescription: newEntryTextView.text, date: newEntryDate.date as Date, location: newEntryLocation.text!, latitude: self.lat, longitude: self.long)
        
        //newEntry.images = self.newEntryPhotos
        newEntry.imageData = self.imageData
        
        
        FBDatabase.SaveJournalToDatabase(journalModel: newEntry) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error Saving", message: "\(error)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    print("OK")
                })
                
                self.present(alert, animated: true)
            }
  
            self.delegate?.newEntryDetails(self.entry!)
            
            //update UI on mainthread. need to pop in main thread, therefor need to use OperationQueue.main.addOperation
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
        }
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
