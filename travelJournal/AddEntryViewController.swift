//
//  AddEntryViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

protocol AddingEntryDelegate {
    func newEntryDetails(_ entry: JournalModel)
}

class AddEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: AddingEntryDelegate?
    var entry : JournalModel?

    @IBOutlet weak var newEntryTitle: UITextField!
    @IBOutlet weak var newEntryLocation: UILabel!
    @IBOutlet weak var newEntryDate: UIDatePicker!
    @IBOutlet weak var newPicturesTableView: UITableView!
    @IBOutlet weak var newEntryTextView: UITextView!
    
    var newEntryPhotos = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AllEntriesTableViewController.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self.view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePickerController, animated: true, completion: nil)
    }
    

    //save button
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!){
        print("myRightSideBarButtonItemTapped")
        
        // pass the new entries in this initializer
//        self.entry = Entry(title: "Title here")
        
        self.delegate?.newEntryDetails(self.entry!)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Database of Photos TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newEntryPhotos.count
    }

    //MARK: - Delegation of Photos TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? UITableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
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
