//
//  BuildMsg.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation

class BuildMsg {
    let reqInfo : FlowModel?
    let type_clear_msg : String = "clear_msg"
    let type_log_in : String = "log_in"
    
    struct ReqMsg : Codable {
        var payload : String
        var req_sec : String
    }
    
    struct ClearMsg : Codable {
        var type : String
        var msg : String
        var sparrow: String
    }
    
    struct LogIn : Codable {
        var type : String
        var user_id : String
    }
    
    init(info: FlowModel){
        reqInfo = info
    }
    
    func getRequestMsg() -> Data? {
        switch reqInfo?.type {
        case .GET_CLEAR_MSG:
            return getClearMsgBody()
        case .NORMAL:
            return getLobbyBody()
        default:
            break
        }
        
        return getLobbyBody()
    }
    
    func getClearMsgBody() -> Data?{
        let clearMsg = reqInfo?.secretMsg ?? ""
        if clearMsg == "" {
            return nil
        }
        
        let info = ClearMsg(type: type_clear_msg, msg: clearMsg, sparrow: "sparrow one")
        guard let data = try? JSONEncoder().encode(info) else {
            return nil
        }
        
        let dataString = String(data: data, encoding: .utf8) ?? ""
        //print("string data = \(dataString)")
        if dataString == "" {
            return nil
        }
        
        let payload = ReqMsg(payload: dataString, req_sec: "01")
        guard let body = try? JSONEncoder().encode(payload) else {
            return nil
        }
        
        return body
    }
    
    func getLobbyBody() -> Data? {
        let user : String = "134ajdr933dafdafa3"
        let info = LogIn(type: type_log_in, user_id: user)
        
        guard let data = try? JSONEncoder().encode(info) else {
            return nil
        }
        
        let dataString = String(data: data, encoding: .utf8) ?? ""
        if dataString == "" {
            return nil
        }
        
        let payload = ReqMsg(payload: dataString, req_sec: "01")
        
        guard let body = try? JSONEncoder().encode(payload) else {
            return nil
        }
        
        return body
    }
}
