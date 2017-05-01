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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 25.0376486, longitude: 121.5617326)
        point.title = "台北市政府"
        point.subtitle = "台北市信義區市府路1號"
        
        mapView.addAnnotation(point)
        
        _ = cafesJSON().then { json in
            self.processGeoJSON(json: json)
        }.then { cafes in
            cafes.map { cafe in
                self.annotationFromCafe(cafe: cafe)
            }
        }.then { annotations in
            annotations.forEach { annotation in
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func cafesRequest() -> DataRequest {
        let baseURL = "http://104.236.125.139:3000"
        let endpoint = "\(baseURL)/cafes"
        let request = Alamofire.request(endpoint, method: .get)
        return request
    }
    
    func cafes() -> Promise<Any> {
        return cafesRequest().responseJSON()
    }
    
    @discardableResult
    func cafesJSON() -> Promise<JSON> {
        return cafes().then { data in
            return JSON(data)
        }
    }
    
    func processGeoJSON(json: JSON) -> [Cafe] {
        let features: JSON = json["features"]
        return features.arrayValue.map({Cafe(fromJSON: $0)})
    }
    
    func annotationFromCafe(cafe: Cafe) -> MGLPointAnnotation {
        let point = MGLPointAnnotation()
        point.coordinate = cafe.coordinate
        point.title = cafe.name
        point.subtitle = cafe.address
        return point
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
        print("lat: \(lat), long: \(long)")
        
        self.id = properties["id"].intValue
        self.uuid = properties["uuid"].stringValue
        self.name = properties["name"].stringValue
        self.address = properties["address"].stringValue
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

extension ViewController: MGLMapViewDelegate {
    
}
