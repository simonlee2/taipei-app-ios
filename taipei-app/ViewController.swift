//
//  ViewController.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 4/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import Mapbox
import PromiseKit
import PMKAlamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    var initialUserLocation: MGLUserLocation? {
        didSet {
            guard let initialUserLocation = initialUserLocation else { return }
            setCenterAndSearch(mapView: mapView, userLocation: initialUserLocation, zoomLevel: 15, radius: "600", limit: nil, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    func addAnnotations(location: String?, radius: String?, limit: String?) {
        API.request(endpoint: .cafes(location, radius, limit))
            .responseJSON()
            .then { JSON($0) }
            .then { json in
                self.processGeoJSON(json: json)
            }.then { cafes in
                cafes.map({$0.annotation})
            }.then { annotations in
                annotations.forEach({self.mapView.addAnnotation($0)})
            }.catch { error in
                print(error)
        }
    }
    
    func processGeoJSON(json: JSON) -> [Cafe] {
        let features: JSON = json["features"]
        return features.arrayValue.map({Cafe(fromJSON: $0)})
    }
    
    func setCenterAndSearch(mapView: MGLMapView, userLocation: MGLUserLocation, zoomLevel: Double, radius: String?, limit: String?, animated: Bool) {
        mapView.setCenter(userLocation.coordinate, zoomLevel: zoomLevel, animated: animated)
     
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let locationString = "@\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"
        
        addAnnotations(location: locationString, radius: "600", limit: nil)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        guard let userLocation = mapView.userLocation else { return }
        
        setCenterAndSearch(mapView: mapView, userLocation: userLocation, zoomLevel: 15, radius: "600", limit: nil, animated: true)
    }
}

extension ViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if initialUserLocation == nil {
            guard let userLocation = userLocation else { return }
            initialUserLocation = userLocation
        }
    }
}
