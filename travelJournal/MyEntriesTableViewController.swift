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
        
        userID = (Auth.auth().currentUser?.uid)!   ///// current user
        
        FBDatabase.GetJournalsFromDatabase { (journalArray) in
            self.entries = journalArray
            self.filterEntries()
            self.myEntriesTableView.reloadData()
            
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myEntriesTableView.reloadData()
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
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let entry = filteredArray[indexPath.row]
        
        if !(entry.imageLocations.isEmpty) {
            FBDatabase.GetJournalImages(imageLocation:
            entry.imageLocations[0]) { (image) in
                cell.myEntriesImageView.image = image
            }
        } else {
            cell.imageView?.image = UIImage(named: "default.png")
        }
        
        cell.backgroundColor = UIColor.orange
        
        cell.myEntriesLabelTitle.text = entry.title
        cell.myEntriesLabelDescription.text = entry.tripDescription
        //        cell.myEntriesImageView.image = entry.images[0]
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
