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
            self.entries.removeAll()
            self.allEntriesTableViewController.reloadData()
        }
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
        
        print("indexpath: \(indexPath.row)")
        print("localpathcount: \(entry.localImagePath.count)")
        
        if entry.localImagePath.count < 1 {
            
            if entry.imageLocations.count > 0 {
                let imageLog = entry.imageLocations[0]
                
                FBDatabase.GetJournalImages(imageLocation: imageLog) { (image, localImagePath) in
                    cell.allEntriesImageView.image = image
                    entry.localImagePath.append(localImagePath)
                }
            } else {
                //cell.imageView?.image = UIImage(named: "default.png")
                cell.allEntriesImageView.image = UIImage(named: "default.png")
            }
        } else {
            //fetch from drive
            let fp = entry.localImagePath[0]
            print("fp: \(fp)")
            let imageURL = URL(fileURLWithPath: fp)
            
            let image = UIImage(contentsOfFile: imageURL.path)!
            cell.allEntriesImageView.image = image
        }

        
        
        cell.allEntriesCellLabel.text = entry.title
        cell.allEntriesLabelDescription.text = entry.tripDescription
//        cell.allEntriesImageView.image = entry.images[0]
        
        return cell
    }
    
    

    
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
            
            FBDatabase.DeleteJournalFromDatabase(journalModel: entries[indexPath.row])
            self.entries.remove(at: indexPath.row)
            
            self.allEntriesTableViewController.deleteRows(at: [indexPath], with: .fade)
        }
    
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
