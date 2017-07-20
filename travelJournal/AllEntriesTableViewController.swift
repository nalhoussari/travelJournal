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
        
       // DispatchQueue.global(qos: .userInitiated).async {
        
//            //starting the spinner
//            self.allEntriesTableViewController.addSubview(self.spinner)
//            self.spinner.center = self.allEntriesTableViewController.center
//            self.spinner.color = UIColor.black
//            self.spinner.startAnimating()
//            self.spinner.hidesWhenStopped = true
        
            //calling data
            FBDatabase.GetJournalsFromDatabase { (journalArray) in
                self.entries = journalArray
                self.allEntriesTableViewController.reloadData()
            }
            // Bounce back to the main thread to update the UI
//            DispatchQueue.main.async {
////                self.spinner.stopAnimating()
//            }
       // }
        
//        //starting the spinner
//        self.spinner.startAnimating()
//        self.spinner.hidesWhenStopped = true
//        
//        //calling data
//        FBDatabase.GetJournalsFromDatabase { (journalArray) in
//            self.entries = journalArray
//            
//            self.allEntriesTableViewController.reloadData()
//            self.spinner.stopAnimating()
//        }
        
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
        
        print("indexpath: \(indexPath.row)")
        print("localpathcount: \(entry.localImagePath.count)")
        
//        cell.allEntriesImageView.addSubview(cell.spinner)
        cell.spinner.center = (cell.allEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true
        
        if entry.localImagePath.count < 1 {
            
            if entry.imageLocations.count > 0 {
                let imageLog = entry.imageLocations[0]
                
                FBDatabase.GetJournalImages(imageLocation: imageLog) { (image, localImagePath) in
                    //stopping the spinner
                    cell.spinner.stopAnimating()
                    cell.allEntriesImageView.image = image
                    entry.localImagePath.append(localImagePath)
                }
            } else {
                //cell.imageView?.image = UIImage(named: "default.png")
                cell.spinner.stopAnimating()
                cell.allEntriesImageView.image = UIImage(named: "default.png")
            }
        } else {
            //fetch from drive
            let fp = entry.localImagePath[0]
            print("fp: \(fp)")
            let imageURL = URL(fileURLWithPath: fp)
            cell.spinner.stopAnimating()
            let image = UIImage(contentsOfFile: imageURL.path)!
//            self.spinner.stopAnimating()
            cell.allEntriesImageView.image = image
        }

        
        
        cell.allEntriesCellLabel.text = entry.title
        cell.allEntriesLabelDescription.text = entry.tripDescription
//        cell.allEntriesImageView.image = entry.images[0]
        
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
