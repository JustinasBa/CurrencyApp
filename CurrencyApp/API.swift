//
//  API.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-27.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


func API(_ request: APIRouter, completionHandler: @escaping (JSON) -> Void) {
    Alamofire
    .request(request)
    .validate()
    .responseJSON { response in
        if response.result.error != nil {
            if let errorRespData = response.data {
                let jsonEror = JSON(data: errorRespData)
                print(jsonEror)
            }
            return completionHandler(JSON.null)
            
        } else {
            var json: JSON = JSON.null
            
            if let jsonData = response.result.value {
                json = JSON(jsonData)
            }
            return completionHandler(json)
        }
    }

    }


