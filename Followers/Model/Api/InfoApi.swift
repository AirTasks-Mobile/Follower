//
//  InfoApi.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Foundation
import Combine

protocol ApiInterface {
    func getURLRequest() -> URLRequest
    func setupNetwork() -> Void
    func buildPayload() -> Data
    func connectHost<T: Decodable>() -> AnyPublisher<T, FlowError>
}

struct ResInfo : Decodable {
    var payload : String?
    var res_sec : String?
}

class InfoApi : ApiInterface {
    
    func getURL() -> URL {
        let url = "http://192.168.43.11:5000/api"
        
        
        return URL(string: url + "/mock")!
    }
    
    func getMethod() -> String {
        return "POST"
    }
    
    func getURLRequest() -> URLRequest {
        let url = getURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = getMethod()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func setupNetwork() {
        //
    }
    
    func buildPayload() -> Data {
        let build = BuildMsg()
        
        return build.getRequestMsg()!
    }
    
    
    func connectHost<T: Decodable>() -> AnyPublisher<T, FlowError> {
        var request = getURLRequest()
        request.httpBody = buildPayload()

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let res = output.response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                    throw FlowError.FAIL
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error -> FlowError in
                //print("error = \(error.localizedDescription)")
                return FlowError.FAIL
            }
            .eraseToAnyPublisher()
    }
    
//    func analyzeResponse(data: Data, type: String) {
//        if type == "application/json" {
//            let stringData = String(data: data, encoding: .utf8)
//            processJsonResponse(res: stringData ?? "")
//        }
//    }
    
 
}
