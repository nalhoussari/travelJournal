//
//  JournalModel.swift
//  travelJournal
//
//  Created by Kevin Cleathero on 2017-07-14.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit

class JournalModel : NSObject {
    
    var id:Int
    var title:String
    var tripDescription:String
    //var images:[UIImage]
    //    var quotes = [QuoteModel]()
    var imageLocations = [String]()
    
    var date:NSNumber
    var location:String
    var latitude:NSNumber
    var longitude:NSNumber
    var fireBaseKey = String()
    
    
    init(id:Int, title:String, tripDescription:String, date:NSDate, location:String, latitude:NSNumber, longitude:NSNumber) {
        self.id = id
        self.title = title
        self.tripDescription = tripDescription
        //self.images = images
        self.date = NSNumber.init(value: date.timeIntervalSince1970)
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience override init(){
        
        let id = Int()
        let title = String()
        let tripDescription = String()
        let date = NSDate()
        let location = String()
        let latitude = NSNumber()
        let longitude = NSNumber()
        
        self.init(id:id, title:title, tripDescription:tripDescription, date:date, location:location, latitude:latitude, longitude:longitude)
    }
    
    
    //lazy variable
    var journalDictionary:[String:Any] {
        return ["id": id, "title": title, "tripDescription": tripDescription, "date": date, "imageLocations": imageLocations, "location": location, "latitude": latitude, "longitude": longitude]
    }
    
}
