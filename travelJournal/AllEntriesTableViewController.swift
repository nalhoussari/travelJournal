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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TabBarController.myRightSideBarButtonItemTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        self.fetchData()
        
    }
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        
        performSegue(withIdentifier: "newEntry", sender: sender)
    }


    override func viewWillAppear(_ animated: Bool) {
        
        self.fetchData()
    }
    
   
    func fetchData(){
        //calling data
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            
            if let journalArray = journalArray {
                
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
    
    
    //MARK: - Delegation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allEntriesCell", for: indexPath) as? AllEntriesTableViewCell else {
            fatalError("The dequeued cell is not an instance of AllEntriesTableViewCell.")
        }
        
        let user = self.uniqueUsers[indexPath.section]
        let userEntries = dataSource[user]
        let entry = userEntries?[indexPath.row]
        
        
        print("indexpath: \(indexPath.row)")
        
        cell.spinner.center = (cell.allEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true
        
        
        if entry?.isLiked == 1 {
            cell.likeButton.isSelected = true
        } else{
            cell.likeButton.isSelected = false
        }

      
        if (entry?.localImagePath.count)! < 1 {
            if (entry?.imageLocations.count)! > 0 {
                let imageLog = entry?.imageLocations[0]
                
                FBDatabase.GetJournalImages(imageLocation: imageLog!) { (image, localImagePath, error) in
                    //stopping the spinner
                    cell.spinner.stopAnimating()
                    cell.allEntriesImageView.image = image
                    entry?.localImagePath.append(localImagePath)
                }
            } else {
                cell.spinner.stopAnimating()
                cell.allEntriesImageView.image = UIImage(named: "default.png")
            }
        } else {
            //fetch from drive
            let fp = entry?.localImagePath[0]
            print("fp: \(String(describing: fp))")
            let imageURL = URL(fileURLWithPath: fp!)
            cell.spinner.stopAnimating()
            
            //need guard here!!
            let image = UIImage(contentsOfFile: imageURL.path)!
            cell.allEntriesImageView.image = image
        }
        
        cell.allEntriesCellLabel.text = entry?.title
        cell.allEntriesLabelDescription.text = "   " + (entry?.location)!
        
        cell.journalObject = entry
        
        return cell
    }
    
    
    //MARK - Delete delegates
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        let userID = (Auth.auth().currentUser?.email)!   ///// current user
        
        //need to get section name...
        let user = self.uniqueUsers[indexPath.section]
        
        //...to use as the key for the datasource dictionary to get the array of journals
        let sectionArray = dataSource[user]
        let currentJournal = sectionArray?[indexPath.row]
        
        
        print("/n")
        print("userId: ", userID)
        print("journalID: ", currentJournal?.id as Any)
        
        if userID == currentJournal?.id {
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
            
            
            //need to get section name...
            let user = self.uniqueUsers[indexPath.section]
            
            //...to use as the key for the datasource dictionary to get the array of journals
            let sectionArray = dataSource[user]
            let currentJournal = sectionArray?[indexPath.row]
            
            // handle delete (by removing the data from your array and updating the tableview)
            FBDatabase.DeleteJournalFromDatabase(journalModel: currentJournal!)

            dataSource[user]?.remove(at: indexPath.row)

            allEntriesTableViewController.deleteRows(at: [indexPath], with: .fade)
    
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
}


