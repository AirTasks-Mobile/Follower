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
        var payload : String
        var req_type : String
        var req_sec: String
    }
    
    struct LogIn : Codable {
        var type : String
        var user_id : String
        var device_id : String
    }
    
    init(info: FlowModel){
        reqInfo = info
    }
    
    func getRequestMsg() -> Data? {
        switch reqInfo?.type {
        case .GET_CLEAR_MSG:
            return getClearMsgBody()
        case .GET_SECRET_MSG:
            return getSecretMsgBody()
        case .NORMAL:
            return getLobbyBody()
        default:
            break
        }
        
        return getLobbyBody()
    }
    
    func getSecretMsgBody() -> Data?{
        let msg = reqInfo?.clearMsg ?? ""
        if msg == "" {
            return nil
        }
        
        let pigeon = "pigeon one     !"
        guard let utf8Pigeon = pigeon.data(using: .utf8) else {
            return nil
        }
        
        let b64Pigeon = utf8Pigeon.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        guard let utf8Msg = msg.data(using: .utf8) else {
            return nil
        }
        let b64Msg = utf8Msg.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        let payload = ClearMsg(payload: b64Msg, req_type: "ENC", req_sec: b64Pigeon)
        guard let body = try? JSONEncoder().encode(payload) else {
            return nil
        }
        
        return body
    }
    
    func getClearMsgBody() -> Data?{
        let msg = reqInfo?.secretMsg ?? ""
        if msg == "" {
            return nil
        }
        
        let sparrow = "sparrow one    !"
        guard let utf8Sparrow = sparrow.data(using: .utf8) else {
            return nil
        }
        
        let b64Sparrow = utf8Sparrow.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        if b64Sparrow.isEmpty {
            return nil
        }
        
        let payload = ClearMsg(payload: msg, req_type: "DEC", req_sec: b64Sparrow)
        guard let body = try? JSONEncoder().encode(payload) else {
            return nil
        }
        
        return body
    }
    
    func getLobbyBody() -> Data? {
        //20210723101956keNSIneFrLUo81rzSnPGkrbp7e2Wpfcpljlmv0mhxkU
        let user : String = reqInfo?.userID ?? "new_user"
        var device : String = reqInfo?.deviceID ?? "old_user"
        
        if user != "" && user != "new_user" {
            device = "old_user"
        }
        
        let info = LogIn(type: type_log_in, user_id: user, device_id: device)
        
        guard let data = try? JSONEncoder().encode(info) else {
            return nil
        }
        
//        let dataString = String(data: data, encoding: .utf8) ?? ""
//        if dataString == "" {
//            return nil
//        }
        
        
        let b64String : String = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        if b64String.isEmpty {
            return nil
        }
        print("payload = \(b64String)")
        
        let payload = ReqMsg(payload: b64String, req_sec: "01")
        
        guard let body = try? JSONEncoder().encode(payload) else {
            return nil
        }
        
        return body
    }
}
