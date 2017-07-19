//
//  AllEntriesTableViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class AllEntriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingEntryDelegate {
    
    var entries = [JournalModel]()
    @IBOutlet weak var allEntriesTableViewController: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBDatabase.GetJournalsFromDatabase { (journalArray) in
            self.entries = journalArray
            self.allEntriesTableViewController.reloadData()
        }
        
//        let entry1 = Entry(title: "Trip!")
//        let entry2 = Entry(title: "Trip 2 Yaaay!")
//        let entry3 = Entry(title: "Trip 3 Yaaay!")
//        let entry4 = Entry(title: "Trip 4 Yaaay!")
//        let entry5 = Entry(title: "Trip 5 Yaaay!")
//        
//        self.entries.append(entry1)
//        self.entries.append(entry2)
//        self.entries.append(entry3)
//        self.entries.append(entry4)
//        self.entries.append(entry5)
        
    }
    
    //AddingNewEntry Delegation function
    func newEntryDetails(_ entry: JournalModel){
        self.entries.append(entry)
        self.allEntriesTableViewController.reloadData()
    }
    
    //MARK: - Database
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    //MARK: - Delegation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allEntriesCell", for: indexPath) as? AllEntriesTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let entry = entries[indexPath.row]
        
        cell.backgroundColor = UIColor.red
        
        print(entry.imageLocations.count)
        if entry.imageLocations.count > 0 {
            let imageLog = entry.imageLocations[0]
            FBDatabase.GetJournalImages(imageLocation: imageLog) { (image) in
                cell.allEntriesImageView.image = image
            }
        } else {
            cell.imageView?.image = UIImage(named: "default.png")
        }
        
        cell.allEntriesCellLabel.text = entry.title
        cell.allEntriesLabelDescription.text = entry.tripDescription
//        cell.allEntriesImageView.image = entry.images[0]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.allEntriesTableViewController.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let entryDetailsViewController = segue.destination as? EntryDetailsViewController
            entryDetailsViewController?.entry = self.entries[selectedRow]
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
