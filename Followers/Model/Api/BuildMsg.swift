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
            case .NORMAL:
                return getLobbyBody()
            case .GET_SOL_BALANCE:
                return getSolBalanceBody()
            case .GET_SOL_ACC_INFO:
                return getSolAccountInfoBody()
            case .GET_SOL_TXN_INFO:
                return getSolTransactionInfoBody()
            case .GET_SOL_STAKE_INFO:
                return getSolStakeBody()
            case .GET_ONE_BALANCE:
                return getOneBalanceBody()
            case .GET_ONE_ACC_INFO:
                return getOneTransactionBody()
            case .GET_ONE_STAKE_INFO:
                return getOneStakeBody()
            case .GET_MATIC_BALANCE:
                return getEthBalanceBody()
            case .GET_BSC_BALANCE:
                return getEthBalanceBody()
        case .GET_ETH_BALANCE:
            return getEthBalanceBody()
            default:
                break
        }
        
        return getLobbyBody()
    }
    
    func getSolBalanceBody() -> Data? {
        struct SolInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "getBalance"
            var params : [String]
            //var params : [ [String] ]
        }
        
        
        // alice : 9eYn5QXiWEmC6jCqkBUgdqCbAZXJtmopktz5XYwCPGCM
        // bob : EWBy8H1XxKb4yzs436TZBxJ7hPoPipYePDixzz1KZ71h
        // my : DpgoQ5ZR6EnjrgWjD9m5cxxGu6NLCypFLTd36nDDjBJb
        //let accountList = ["9eYn5QXiWEmC6jCqkBUgdqCbAZXJtmopktz5XYwCPGCM", "EWBy8H1XxKb4yzs436TZBxJ7hPoPipYePDixzz1KZ71h"]
        let sendInfo = SolInfo(params: [reqInfo?.token ?? ""])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getSolAccountInfoBody() -> Data? {
        struct SolInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "getSignaturesForAddress"
            var params : [String]
        }
        
        
        // alice : 9eYn5QXiWEmC6jCqkBUgdqCbAZXJtmopktz5XYwCPGCM
        // bob : EWBy8H1XxKb4yzs436TZBxJ7hPoPipYePDixzz1KZ71h
        // my : DpgoQ5ZR6EnjrgWjD9m5cxxGu6NLCypFLTd36nDDjBJb
        //let accountList = ["9eYn5QXiWEmC6jCqkBUgdqCbAZXJtmopktz5XYwCPGCM", "EWBy8H1XxKb4yzs436TZBxJ7hPoPipYePDixzz1KZ71h"]
        let sendInfo = SolInfo(params: [reqInfo?.token ?? ""])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getSolTransactionInfoBody() -> Data? {
        struct SolInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "getTransaction"
            var params : [String]
        }
        
        let sendInfo = SolInfo(params: [reqInfo?.token ?? ""])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getSolStakeBody() -> Data? {
        struct SolInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "getInflationReward"
            var params : [[String]]
        }

        // my : DpgoQ5ZR6EnjrgWjD9m5cxxGu6NLCypFLTd36nDDjBJb
        //let abc = ["7yVybDbMQPrkm3fc5KAURZygwLCQiHDfGnS4d3JoNiXk"]
        
        let sendInfo = SolInfo(params: [reqInfo?.stakes ?? []])
   
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
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
    
    // One
    func getOneBalanceBody() -> Data? {
        struct OneInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : String = "1"
            var method : String = "hmyv2_getBalance"
            var params : [String]
        }
        
        let sendInfo = OneInfo(params: [reqInfo?.token ?? ""])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getOneTransactionBody() -> Data? {
        struct Param : Codable {
            var address : String
            var pageIndex = 0
            var pageSize = 1000
            var fullTx = true
            var txType = "ALL"
            var order = "DESC"
        }
        
        struct OneInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : String = "1"
            var method : String = "hmyv2_getTransactionsHistory"
            var params : [Param]
        }
        
        let sendInfo = OneInfo(params: [Param(address: reqInfo?.token ?? "")])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getOneStakeBody() -> Data? {
        struct OneInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : String = "1"
            var method : String = "hmy_getDelegationsByDelegator"
            var params : [String]
        }
        
        let sendInfo = OneInfo(params: [reqInfo?.token ?? ""])
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    // Matic
    func getEthBalanceBody() -> Data? {
        struct MaticInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "eth_getBalance"
            var params : [String]
        }
        //eth_getTransactionCount : work
        //eth_getBalance
        // my : // 0xBaB4d45cEe1F8F6153e06DE71DdE21B74E0CfD9B
        
//        if true {
//            return getEthAccountBody()
//        }
//        
        let info = ["\(reqInfo?.token ?? "")", "latest"]
        let sendInfo = MaticInfo(params: info)
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
    
    func getEthAccountBody() -> Data? {
        struct MaticInfo : Codable {
            var jsonrpc : String = "2.0"
            var id : Int = 1
            var method : String = "eth_getCode"
            var params : [String]
        }
        
        // my : // 0xBaB4d45cEe1F8F6153e06DE71DdE21B74E0CfD9B
        // getLogs : does not exist
    
        let info = ["\(reqInfo?.token ?? "")", "latest"]
        let sendInfo = MaticInfo(params: info)
        
        guard let body = try? JSONEncoder().encode(sendInfo) else {
            return nil
        }
        
        //print("body = \(body)")
        //print("JSON body: \(String(data: body, encoding: .utf8))")
        
        return body
    }
}
