//
//  RestApi.swift
//  KineduTest
//
//  Created by Vicente Cantu Garcia on 5/24/19.
//  Copyright © 2019 Vicente Cantu Garcia. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

fileprivate let BASE_URL = "http://demo.kinedu.com"

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

class RestApi {
    
    static func getNPS(onResponse: @escaping ([NPS]) -> Void, onError: @escaping () -> Void, notConnection: @escaping () -> Void) {
        
        let endPoint = BASE_URL + "/bi/nps"

        Alamofire.request(endPoint.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: .get, headers: [:]).responseArray { (response: DataResponse<[NPS]>) in
            if NetworkReachabilityManager()!.isReachable {
                if response.result.isSuccess {
                    
                    let response = response.result.value
                    onResponse(response!)

                } else {
                    onError()
                }
            } else {
                notConnection()
            }
        }
    }
    
}
