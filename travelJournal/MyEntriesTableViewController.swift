//
//  MyListViewController.swift
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


class MyEntriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingEntryDelegate {
    
    var entries = [JournalModel]()
    var filteredArray = [JournalModel]()
    //    var journalModel = JournalModel()
    
    var userID : String = ""
    
    
    @IBOutlet weak var myEntriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = (Auth.auth().currentUser?.email)!   ///// current user
        self.getRecords()
    }
    
    func filterEntries()
    {
        filteredArray.removeAll()
        for entry in self.entries
        {
            
            if entry.id == userID
            {
                filteredArray.append(entry)
            }
        }
        
        self.myEntriesTableView.reloadData()
    }
    
    func getRecords(){
        FBDatabase.GetJournalsFromDatabase { (journalArray) in
            self.entries = journalArray
            self.filterEntries()
            self.myEntriesTableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getRecords()
    }
    
    //AddingNewEntry Delegation function
    func newEntryDetails(_ entry: JournalModel){
        self.filteredArray.append(entry)
        self.myEntriesTableView.reloadData()
    }
    
    //MARK: - Database
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofrowsInSection", filteredArray.count)
        return filteredArray.count
    }
    
    //MARK: - Delegation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myEntryCell", for: indexPath) as? MyEntriesTableViewCell else {
            fatalError("The dequeued cell is not an instance of MyEntriesTableViewCell.")
        }
        
        let entry = filteredArray[indexPath.row]
        
        //        cell.allEntriesImageView.addSubview(cell.spinner)
        cell.spinner.center = (cell.myEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true
        
        if entry.localImagePath.count < 1 {
            if entry.imageLocations.count > 0 {
                
                FBDatabase.GetJournalImages(imageLocation:
                entry.imageLocations[0]) { (image, localImagePath) in
                    
                    //stopping the spinner
                    cell.spinner.stopAnimating()
                    cell.myEntriesImageView.image = image
                    entry.localImagePath.append(localImagePath)
                }
            } else {
                //stopping the spinner
                cell.spinner.stopAnimating()
                cell.myEntriesImageView.image = UIImage(named: "default.png")
            }
        } else {
            //fetch from drive
            let fp = entry.localImagePath[0]
            print("fp: \(fp)")
            let imageURL = URL(fileURLWithPath: fp)
            
            //stopping the spinner
            cell.spinner.stopAnimating()
            
            let image = UIImage(contentsOfFile: imageURL.path)
            cell.myEntriesImageView.image = image
        }
        
        cell.backgroundColor = UIColor.orange
        
        cell.myEntriesLabelTitle.text = entry.title
        cell.myEntriesLabelDescription.text = entry.tripDescription
        //        cell.myEntriesImageView.image = entry.images[0]
        
        return cell
    }
    
    //MARK - Delete delegates
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            FBDatabase.DeleteJournalFromDatabase(journalModel: filteredArray[indexPath.row])
            self.filteredArray.remove(at: indexPath.row)
            self.myEntriesTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.myEntriesTableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let entryDetailsViewController = segue.destination as? EntryDetailsViewController
            entryDetailsViewController?.entry = self.filteredArray[selectedRow]
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
