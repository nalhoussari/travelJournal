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
    var currPin = CustomPointAnnotation()
    var populatedJournal = JournalModel()

    
    var currImg = UIImage()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius : CLLocationDistance = 1000
    var annotations : [CustomPointAnnotation]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TabBarController.myRightSideBarButtonItemTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        mapView.delegate = self
        mapView.mapType = MKMapType.hybrid
        let initialLocation = CLLocation(latitude: 49.2819, longitude: -123.1083)
        centerMapOnLocation(initialLocation)
        getRecords()
    }
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        
        performSegue(withIdentifier: "newEntry", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecords()
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func getRecords(){
        
        FBDatabase.GetJournalsFromDatabase { (journalArray, error) in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
            } else {
            
                OperationQueue.main.addOperation {
                    print("journaarray count: ", journalArray?.count ?? "")
                    self.entries = journalArray!
                    
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations.removeAll()
                
                    self.pinEntries()
                }
            }
        }
    }
    
    func pinEntries(){
        
        for entryTemp in (self.entries){

            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(entryTemp.latitude), CLLocationDegrees(entryTemp.longitude))
            annotation.title = entryTemp.title
            annotation.subtitle = entryTemp.location
            annotation.currEntry = entryTemp

            annotations.append(annotation)
        }
        
            self.mapView.addAnnotations(self.annotations)
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
            
            let callOutImg = UIImageView(image: #imageLiteral(resourceName: "Icon"))
            pinView!.leftCalloutAccessoryView = callOutImg
            
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?, journal:JournalModel) {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapToDetail")
        {
            let journal = (sender as! CustomPointAnnotation).currEntry
            let mapSegue = segue.destination as! EntryDetailsViewController
            mapSegue.setJournalItem(journal)
        }
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("Button taped ")
            self.performSegue(withIdentifier: "mapToDetail", sender: self.currPin)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        if let annotation = view.annotation as? CustomPointAnnotation {
            currPin = annotation
        }
    }
}
        
    class CustomPointAnnotation: MKPointAnnotation {
        var currEntry = JournalModel()
    }
