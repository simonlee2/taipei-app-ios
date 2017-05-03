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
import Alamofire
import PMKAlamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var currentLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        addAnnotations(location: "@25.051,121.54654", radius: "600", limit: nil)
        
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
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        guard let userLocation = mapView.userLocation else { return }
        
        mapView.setCenter(userLocation.coordinate, zoomLevel: 15, animated: true)
        
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let locationString = "@\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"
        
        addAnnotations(location: locationString, radius: "600", limit: nil)
    }
}

struct Cafe {
    var id: Int
    var uuid: String
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
}

extension Cafe {
    init(fromJSON json: JSON) {
        let coordinate = json["geometry"]["coordinates"].arrayValue.map({$0.doubleValue})
        let properties = json["properties"]
        let lat = coordinate[1]
        let long = coordinate[0]
        
        self.id = properties["id"].intValue
        self.uuid = properties["uuid"].stringValue
        self.name = properties["name"].stringValue
        self.address = properties["address"].stringValue
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var annotation: MGLPointAnnotation {
        let point = MGLPointAnnotation()
        point.coordinate = coordinate
        point.title = name
        point.subtitle = address
        return point
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
}
