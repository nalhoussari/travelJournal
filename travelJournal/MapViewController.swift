//
//  MapViewController.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-13.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    //MARK: - Properties
    var entries = [JournalModel]()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius : CLLocationDistance = 1000
    var annotations : [MKPointAnnotation]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.hybrid
        let initialLocation = CLLocation(latitude: 49.2819, longitude: -123.1083)
        centerMapOnLocation(initialLocation)
        getRecords()
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getRecords(){
        FBDatabase.GetJournalsFromDatabase { (journalArray) in
            self.entries = journalArray
            self.pinEntries()
        }
    }
    func pinEntries(){
        for entryTemp in (self.entries){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(entryTemp.latitude), CLLocationDegrees(entryTemp.longitude))
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)

    }
    
}
