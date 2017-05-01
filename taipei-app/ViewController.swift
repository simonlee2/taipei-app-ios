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
    }
    
    func cafesRequest() -> Request {
        let baseURL = "104.236.125.139:3000"
        let endpoint = "\(baseURL)/cafes"
        let request = Alamofire.request(endpoint, method: .get)
        return request
    }
}

extension ViewController: MGLMapViewDelegate {
    
}
