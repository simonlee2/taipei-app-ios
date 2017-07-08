//
//  Cafe.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 5/3/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import CoreLocation
import Mapbox
import SwiftyJSON

enum SocketAvailability: String {
    case yes = "yes"
    case no = "no"
    case maybe = "maybe"
}

struct Cafe {
    let id: Int
    let uuid: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    let cheap: Double
    let music: Double
    let socket: SocketAvailability
    let quiet: Double
    let seat: Double
    let url: String
    let wifi: Double
    let tasty: Double
    let limitedTime: Bool
    let standingDesk: Bool
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
        self.cheap = properties["cheap"].doubleValue
        self.music = properties["music"].doubleValue
        self.socket = SocketAvailability(rawValue: properties["socket"].stringValue) ?? .maybe
        self.quiet = properties["quiet"].doubleValue
        self.seat = properties["seat"].doubleValue
        self.url = properties["url"].stringValue
        self.wifi = properties["wifi"].doubleValue
        self.tasty = properties["tasty"].doubleValue
        self.limitedTime = properties["limited_time"].boolValue
        self.standingDesk = properties["standing_desk"].boolValue
    }
    
    var annotation: MGLPointAnnotation {
        let point = MGLPointAnnotation()
        point.coordinate = coordinate
        point.title = name
        point.subtitle = address
        return point
    }
}

class CafeAnnotation: NSObject, MGLAnnotation {
    let id: Int
    let uuid: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    let cheap : Double
    let music: Double
    let socket: SocketAvailability
    let quiet: Double
    let seat: Double
    let url: String
    let wifi: Double
    let tasty: Double
    let limitedTime: Bool
    let standingDesk: Bool
    
    init(withCafe cafe: Cafe) {
        self.id = cafe.id
        self.uuid = cafe.uuid
        self.name = cafe.name
        self.address = cafe.address
        self.coordinate = cafe.coordinate
        self.cheap = cafe.cheap
        self.music = cafe.music
        self.socket = cafe.socket
        self.quiet = cafe.quiet
        self.seat = cafe.seat
        self.url = cafe.url
        self.wifi = cafe.wifi
        self.tasty = cafe.tasty
        self.limitedTime = cafe.limitedTime
        self.standingDesk = cafe.standingDesk
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
}
