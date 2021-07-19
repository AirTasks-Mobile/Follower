//
//  BuildMsg.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation

class BuildMsg {
    struct ReqMsg : Codable {
        var payload : String
        var req_sec : String
    }
    
    func getRequestMsg() -> Data? {
        return getLobbyBody()
    }
    
    func getLobbyBody() -> Data? {
        let info = ReqMsg(payload: "payload", req_sec: "01")
        
        guard let body = try? JSONEncoder().encode(info) else {
            return nil
        }
        
        return body
    }
}
