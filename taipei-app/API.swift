//
//  API.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 5/1/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import Alamofire

public class API {
    
    public static var baseURL = "http://104.236.125.139:3000"
    
    public enum Endpoints {
        case cafes
        
        public var method: Alamofire.HTTPMethod {
            switch self {
            case .cafes:
                return Alamofire.HTTPMethod.get
            }
        }
        
        public var path: String {
            switch self {
            case .cafes:
                return "\(baseURL)/cafes"
            }
        }

    }
}
