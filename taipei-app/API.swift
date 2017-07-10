//
//  API.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 5/1/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class API {
    
    public static var baseURL = "http://104.236.125.139:3000"
    
    public enum Endpoints {
        case cafes(String?, String?, String?)
        case bounds(String?, String?)
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .cafes, .bounds:
                return Alamofire.HTTPMethod.get
            }
        }
        
        public var path: String {
            switch self {
            case .cafes, .bounds:
                return "\(baseURL)/cafes"
            }
        }
        
        public var parameters: [String : Any] {
            var parameters: [String: String] = [:]
            switch self {
            case .cafes(let location, let radius, let limit):
                parameters["location"] = location
                parameters["radius"] = radius
                parameters["limit"] = limit
                break
            case .bounds(let sw, let ne):
                parameters["sw"] = sw
                parameters["ne"] = ne
                break
            }
            
            return parameters
        }
    }
    
    public static func request(endpoint: API.Endpoints) -> DataRequest {
        return Alamofire.request(
            endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters)
    }
}
