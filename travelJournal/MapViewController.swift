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


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties
    var entries = [JournalModel]()
    var currEntry = JournalModel()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius : CLLocationDistance = 1000
    var annotations : [MKPointAnnotation]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            if let error = error {print("Unable to Forward Geocode Address (\(error))")}
        
            self.entries = journalArray!
            self.pinEntries()
        }
        
    }
    func pinEntries(){
        for entryTemp in (self.entries){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(entryTemp.latitude), CLLocationDegrees(entryTemp.longitude))
            annotation.title = entryTemp.title
            annotation.subtitle = entryTemp.tripDescription
            currEntry = entryTemp
            print(currEntry)
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)

    }
    //MARK: - MKMapView Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = false
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
            
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.pinTintColor = UIColor.magenta
                FBDatabase.GetJournalImages(imageLocation: currEntry.imageLocations[0]) { (image, localImagePath) in
//                    let imageLog =
                     pinView?.detailCalloutAccessoryView = UIImageView(image: image)
                }
            
            
            /////////
//            let imageURL = URL(fileURLWithPath: currEntry.imageLocations[0])
//            let imgimg = UIImage(contentsOfFile: imageURL.path)
//            let callOutImg = UIImageView(image: imgimg)
//            pinView!.detailCalloutAccessoryView = callOutImg
            //
            //////////
////                        let imageURL = URL(fileURLWithPath: currEntry.l)
//                        let callOutImg = UIImageView(image: #imageLiteral(resourceName: "default"))
//                        pinView!.detailCalloutAccessoryView = callOutImg
//            //////////
//            let fp = currEntry.imageLocations[0]
//            let imageURL = URL(string: fp)
//            let imageData = Data(contentsOf: imageURL!)
//            let image = UIImage(data: imageData)
//            pinView?.detailCalloutAccessoryView = UIImageView(image: image)
            //////////
            
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("Button taaped ")
        }
    }
}
