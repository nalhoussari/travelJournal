//
//  AllEntriesTableViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class AllEntriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingEntryDelegate {
    
    var entries = [Entry]()
    @IBOutlet weak var allEntriesTableViewController: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //
        //        let addBarButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action:#selector(AllEntriesTableViewController.addEntry))
        
        //        self.navigationItem.rightBarButtonItem = addBarButton
        let rightBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AllEntriesTableViewController.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
    }
    
    //AddingNewEntry Delegation function
    func newEntryDetails(_ entry: Entry){
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
        
        cell.allEntriesCellLabel.text = entry.title
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
