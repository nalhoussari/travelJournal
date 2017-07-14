//
//  TabBarController.swift
//  travelJournal
//
//  Created by Noor Alhoussari on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TabBarController.myRightSideBarButtonItemTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton

    }
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        print("myRightSideBarButtonItemTapped")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
