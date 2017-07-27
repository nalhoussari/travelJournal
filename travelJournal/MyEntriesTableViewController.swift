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
    
    var userID : String = ""
    
    
    @IBOutlet weak var myEntriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TabBarController.myRightSideBarButtonItemTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        self.navigationItem.setHidesBackButton(true, animated: false)

    
        self.getRecords()


    }
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        
        performSegue(withIdentifier: "newEntry", sender: sender)
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
        
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            
        if let journalArray = journalArray {
                self.entries = journalArray
                self.filterEntries()
                self.myEntriesTableView.reloadData()
            
        } else if let error = error {
                
            let alert = UIAlertController(title: "Error Fetching", message: "\(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                print("OK")
            })
            
            self.present(alert, animated: true)
        }
      }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if  Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "toLogin", sender: nil)
        } else {
            userID = (Auth.auth().currentUser?.email)!
        }

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
        
        cell.spinner.center = (cell.myEntriesImageView?.center)!
        cell.spinner.color = UIColor.black
        cell.spinner.startAnimating()
        cell.spinner.hidesWhenStopped = true

        
        if entry.localImagePath.count < 1 {
            if entry.imageLocations.count > 0 {
                
                FBDatabase.GetJournalImages(imageLocation:
                entry.imageLocations[0]) { (image, localImagePath, error) in
                    
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
        
        
        cell.myEntriesLabelTitle.text = entry.title
        cell.myEntriesLabelDescription.text = entry.tripDescription
        
        
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
        
        else if let loginScreen = segue.destination as? LoginViewController {
            
            loginScreen.hidesBottomBarWhenPushed = true
            loginScreen.navigationItem.setHidesBackButton(true, animated: false)
        }
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
