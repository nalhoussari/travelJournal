//
//  JournalModel.swift
//  travelJournal
//
//  Created by Kevin Cleathero on 2017-07-14.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class JournalModel : NSObject {
    
    var id:String
    var title:String
    var tripDescription:String
    var images = [UIImage]()
    var imageLocations = [String]()
    var localImagePath = [String]()
    var imageData = [Data]()
    var date:NSNumber
    var location:String
    var latitude:NSNumber
    var longitude:NSNumber
    var fireBaseKey = String()
    var isLiked:NSNumber = 0
    
    
    init(id:String, title:String, tripDescription:String, date:Date, location:String, latitude:NSNumber, longitude:NSNumber) {
        self.id = id
        self.title = title
        self.tripDescription = tripDescription
        self.date =  NSNumber.init(value: date.timeIntervalSince1970)
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience override init(){
        
        let id = String()
        let title = String()
        let tripDescription = String()
        let date = Date()
        let location = String()
        let latitude = NSNumber()
        let longitude = NSNumber()
        
        self.init(id:id, title:title, tripDescription:tripDescription, date:date, location:location, latitude:latitude, longitude:longitude)
    }
    
    
    //lazy variable
    var journalDictionary:[String:Any] {
        return ["id": id, "title": title, "tripDescription": tripDescription, "date": date, "imageLocations": imageLocations, "location": location, "latitude": latitude, "longitude": longitude, "liked": isLiked]
    }
    
}
