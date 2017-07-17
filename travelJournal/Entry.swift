//
//  Entry.swift
//  travelJournal
//
//  Created by Noor Alhoussari on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import Foundation
import UIKit

class Entry {
    var title : String = ""
    var location : String = ""
    var date : Date = Date()
    var description : String = ""
    var photosArray = [UIImage]()
    
//    init (title: String){
//        self.title = title
//    }
    
    init(title: String, location: String, date: Date, description: String, photosArray: NSMutableArray){
        
        self.title = title
        self.location = location
        self.date = date
        self.description = description
        self.photosArray = photosArray as! [UIImage]
    
    }

    
    
}

