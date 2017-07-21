//
//  AllEntriesTableViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class AllEntriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingEntryDelegate {
        
    @IBOutlet weak var allEntriesTableViewController: UITableView!
    
    var entries = [JournalModel]()
//    var locations = [String]()
    var users = [String]()
    var dataSource = [String:[JournalModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }
    
    func fetchData(){
        //calling data
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            
            if let journalArray = journalArray {
                
                self.entries = journalArray
                
                //getting array of user's e-mails
                for entry in self.entries {
                    self.users.append(entry.id)
                }
                
                print("*********")
                print(self.entries.count)
                print(self.users.count)

                for user in self.users
                {
                    var tempEntries = [JournalModel]()
                    for tempEntry in self.entries
                    {
                        if tempEntry.id == user
                        {
                            tempEntries.append(tempEntry)
                        }
                    }
                    self.dataSource[user] = tempEntries
                }
                
                self.allEntriesTableViewController.reloadData()
                
            } else if let error = error {
                let alert = UIAlertController(title: "Error Fetchin", message: "\(error)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    print("OK")
                })
                
                self.present(alert, animated: true)
            }
        }
    }
    
    
    //AddingNewEntry Delegation function
    func newEntryDetails(_ entry: JournalModel){
        self.entries.append(entry)
        self.allEntriesTableViewController.reloadData()
    }
    
    //MARK: - Database
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.keys.count
    }
    
//    MARK - Adding Sections
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        for user in self.users {
            var numberOfRows = 0
            for entry in self.entries{
                if user == entry.id {
                    numberOfRows += 1
                }
            }
            return numberOfRows
        }
        */
//        let users = dataSource.keys
        let users = Array(dataSource.keys)
        let user = users[section]
        let userEntries = dataSource[user]
        guard let entries = userEntries else { return 0 }
        return entries.count
        
//        return entries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.users[section]
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return self.users
//    }
    
    
    //cell
    
    //MARK: - Delegation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allEntriesCell", for: indexPath) as? AllEntriesTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllEntriesTableViewCell.")
        }
        
//        let entry = entries[indexPath.row]
//        let stringUser = self.users[indexPath.section]
//        
//        var sectionEntries = [JournalModel]()
//        for entryTemp in self.entries {
//            if entryTemp.id == stringUser {
//                sectionEntries.append(entryTemp)
//            }
//        }
//        let entry = sectionEntries[indexPath.row]
        
        let users = Array(dataSource.keys)
        let user = users[indexPath.section]
        let userEntries = dataSource[user]
//        guard let entriesTemp = userEntries else { return 0}
        let entry = userEntries?[indexPath.row]
//        guard let entry = userEntries?[indexPath.row] else { return 0 }
//        return entries.count
        
        cell.backgroundColor = UIColor.red
        
        print("indexpath: \(indexPath.row)")
//        print("localpathcount: \(entry.localImagePath.count)")
        
//        cell.allEntriesImageView.addSubview(cell.spinner)
        cell.spinner.center = (cell.allEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true
        
        if (entry?.localImagePath.count)! < 1 {
            
            if (entry?.imageLocations.count)! > 0 {
                let imageLog = entry?.imageLocations[0]
                
                FBDatabase.GetJournalImages(imageLocation: imageLog!) { (image, localImagePath) in
                    //stopping the spinner
                    cell.spinner.stopAnimating()
                    cell.allEntriesImageView.image = image
                    entry?.localImagePath.append(localImagePath)
                }
            } else {
                //cell.imageView?.image = UIImage(named: "default.png")
                cell.spinner.stopAnimating()
                cell.allEntriesImageView.image = UIImage(named: "default.png")
            }
        } else {
            //fetch from drive
            let fp = entry?.localImagePath[0]
            print("fp: \(fp)")
            let imageURL = URL(fileURLWithPath: fp!)
            cell.spinner.stopAnimating()
            
            //need guard here!!
            let image = UIImage(contentsOfFile: imageURL.path)!
//            self.spinner.stopAnimating()
            cell.allEntriesImageView.image = image
        }
        
        cell.allEntriesCellLabel.text = entry?.title
        cell.allEntriesLabelDescription.text = entry?.tripDescription
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
    

    
    //MARK - Segue
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
