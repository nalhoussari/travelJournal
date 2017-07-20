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
//    @IBOutlet weak var mapView: MKMapView!//map
//    let regionRadius: CLLocationDistance = 1000//map
    @IBOutlet var streetTextField: UITextField!
//    let annotation = MKPointAnnotation()//map
    @IBOutlet var geocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var locationLabel: UILabel!
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Forward Geocoding"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let initialLocation = CLLocation(latitude: 49.2819, longitude: -123.1083)//map
//        centerMapOnLocation(initialLocation)//map
        
//        mapView.mapType = MKMapType.hybrid//map
    }
    // MARK: - Actions
    @IBAction func geocode(_ sender: UIButton) {
        guard let street = streetTextField.text else { return }
        
        // Geocode Address String
        let address = "\(street)"
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        // Update View
        geocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
    }
    
    // MARK: - Helper Methods
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        geocodeButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            locationLabel.text = "Unable to Find Location for Address"
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                locationLabel.text = "\(coordinate.latitude), \(coordinate.longitude)"
//                annotation.coordinate = location.coordinate//map
//                mapView.addAnnotation(annotation)//map
//                centerMapOnLocation(CLLocation(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)) //map
            } else {
                locationLabel.text = "No Matching Location Found"
            }
        }
    }
    
//    func centerMapOnLocation(_ location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius * 3.0, regionRadius * 3.0)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }//map
    
}
