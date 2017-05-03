//
//  Cafe.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 5/3/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import Alamofire
import Mapbox
import SwiftyJSON

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
