//
//  AllEntriesTableViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit
import FirebaseAuth

class AllEntriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingEntryDelegate {
        
    @IBOutlet weak var allEntriesTableViewController: UITableView!
    
    var entries = [JournalModel]()
    var users = [String]()

    var firebaseDatabase = FBDatabase()
    
    @IBOutlet var heartAnimationView: UIImageView!

    var uniqueUsers = [String]()
    var dataSource = [String:[JournalModel]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.fetchData()
    }
    
    //func emptyVariables() {
      //  self.entries = [JournalModel]()
        //self.users = [String]()
       // self.uniqueUsers = [String]()
        //self.dataSource = [String:[JournalModel]]()
    //}
    
    func fetchData(){
        //calling data
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            
            if let journalArray = journalArray {
                
                //emptying the variables before fetching data again to avoid duplicate tableView dublicate dataSource
                //self.emptyVariables()
                
                self.entries = [JournalModel]()
                self.users = [String]()
                self.uniqueUsers = [String]()
                self.dataSource = [String:[JournalModel]]()

                self.entries = journalArray
                
                //getting array of user's e-mails
                for entry in self.entries {
                    self.users.append(entry.id)
                }
                
                print("*********")
                print(self.entries.count)
                print(self.users.count)

                let tempUserSet = NSSet(array: self.users)
                for user in tempUserSet
                {
                    let newString = (user as AnyObject).replacingOccurrences(of: " ", with: "")
                    self.uniqueUsers.append(newString)
                }
                
                for user in self.uniqueUsers
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
        return self.uniqueUsers.count
    }
    
//    MARK - Adding Sections
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let user = self.uniqueUsers[section]
        let userEntries = dataSource[user]
        guard let entries = userEntries else { return 0 }
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let emailPart = self.uniqueUsers[section]
        
        if emailPart.characters.contains("@"){
            let email = emailPart.range(of: "@")?.lowerBound
            let emailString = emailPart.substring(to: email!)
            return emailString
        } else {
            return emailPart
        }
    }
    
    //getting index of users
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return self.users
//    }
    
    
    //cell
    
    //MARK: - Delegation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allEntriesCell", for: indexPath) as? AllEntriesTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllEntriesTableViewCell.")
        }
        
        let user = self.uniqueUsers[indexPath.section]
        let userEntries = dataSource[user]
        let entry = userEntries?[indexPath.row]
        
        cell.backgroundColor = UIColor.red
        
        print("indexpath: \(indexPath.row)")
//        print("localpathcount: \(entry.localImagePath.count)")
        
        cell.spinner.center = (cell.allEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true
        
<<<<<<< HEAD
        
        if entry.localImagePath.count < 1 {
=======
        if (entry?.localImagePath.count)! < 1 {
>>>>>>> master
            
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
            cell.allEntriesImageView.image = image
        }
        
        cell.allEntriesCellLabel.text = entry?.title
        cell.allEntriesLabelDescription.text = entry?.tripDescription
        
        return cell
    }
    
    
    //MARK - Delete delegates
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        let userID = (Auth.auth().currentUser?.email)!   ///// current user
        let currentJournal = entries[indexPath.row]
        
        if userID == currentJournal.id {
            return true
        } else {
            return false
        }
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
            
            let user = self.uniqueUsers[indexPath.section]
            let userEntries = dataSource[user]
            let entryToPass = userEntries?[indexPath.row]
            
            let entryDetailsViewController = segue.destination as? EntryDetailsViewController
            entryDetailsViewController?.entry = entryToPass
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
<<<<<<< HEAD
    }
    
    
    @IBAction func doubleTappedSelfie(_ sender: UITapGestureRecognizer) {
        print("double tapped selfie")
        

        // get the location (x,y) position on our tableView where we have clicked
        let tapLocation = sender.location(in: allEntriesTableViewController)
        
        // based on the x, y position we can get the indexPath for where we are at
        if let indexPathAtTapLocation = allEntriesTableViewController.indexPathForRow(at: tapLocation){
            
            // based on the indexPath we can get the specific cell that is being tapped
            let cell = allEntriesTableViewController.cellForRow(at: indexPathAtTapLocation) as! AllEntriesTableViewCell
            
            //run a method on that cell
            cell.tapAnimation()
 
        }
    }
=======
    }   
    
>>>>>>> master
}
