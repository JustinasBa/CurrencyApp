//
//  APIRouter.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-26.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIRouter: URLRequestConvertible {
    
    static let baseURL = URL(string: "http://api.evp.lt/")!
    
    case exhangeRate(String, String)
    case exhangeCurrency(String, String, String)
    
    var method: HTTPMethod {
        switch self {
        case .exhangeRate, .exhangeCurrency:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .exhangeRate(let from, let to):
            return "currency/commercial/exchange/1-\(from)/\(to)/latest"
        case .exhangeCurrency(let amount, let from, let to):
            return "currency/commercial/exchange/\(amount)-\(from)/\(to)/latest"
        }
    }
    func asURLRequest() throws  -> URLRequest {
        
        var urlRequest = URLRequest(url: APIRouter.baseURL.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .exhangeRate:
            return urlRequest
            
        case .exhangeCurrency:
            return urlRequest
        }
    }
}
