//
//  BaseFlow.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

enum FLOW : String {
    case NORMAL = "NORMAL"
    case GET_CLEAR_MSG = "GET_CLEAR_MSG"
    case GET_SECRET_MSG = "GET_SECRET_MSG"
    //
    case GET_SOL_BALANCE = "GET_SOL_BALANCE"
    case GET_SOL_ACC_INFO = "GET_ACCOUNT_INFO"
    case GET_SOL_TXN_INFO = "GET_SOL_TXN_INFO"
    case GET_SOL_STAKE_INFO = "GET_SOL_STAKE_INFO"
    
    //
    case GET_ONE_BALANCE = "GET_ONE_BALANCE"
    case GET_ONE_ACC_INFO = "GET_ONE_ACC_INFO"
    case GET_ONE_STAKE_INFO = "GET_ONE_STAKE_INFO"
    
    //
    case GET_MATIC_BALANCE = "GET_MATIC_BALANCE"
    case GET_MATIC_ACC_INFO = "GET_MATIC_ACC_INFO"
    
    //
    case GET_BSC_BALANCE = "GET_BSC_BALANCE"
    
    //
    case GET_ETH_BALANCE = "GET_ETH_BALANCE"
    
    //
    case GET_STELLAR_ACCOUNT = "GET_XLM_ACCOUNT"
    case GET_STELLAR_OPERATION = "GET_STELLAR_OPERATION"
}

enum FlowError : Error {
    //case SUCC
    case FAIL
    case NETWORK
    case SERVER
    case NOT_ALLOW
}

struct FlowModel {
    var isSuccess: Bool = false
    var type : FLOW = .NORMAL
    var message : String?
    var token : String?

    var balance : String?
    var signature : [String]?
    var transaction : TransactionInfo?
    var transactions : [TransactionInfo]?
    var stakes : [String]?
    var liqidities : [String]?
    var assets : [AssetInfo]?
    var cursor : Double?
    
    var deviceID : String?
    var userID : String?
}

protocol FlowProtocol {
    func onStart() -> Bool
    func onExecute() -> AnyPublisher<FlowModel, FlowError>
    func onEnd(info: FlowModel)
}

class BaseFlow: FlowProtocol {
    var viewInfo : [String:String] = [:]
    
    func setViewInfo(info : [String:String]) -> Void {
        viewInfo = info
    }
    
    func onStart() -> Bool {
        //print("onStart")
        return true
    }
    
    func onEnd(info: FlowModel) {
        //print("onEnd")
    }
    
    func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        return Just(FlowModel())
            .setFailureType(to: FlowError.self)
            .eraseToAnyPublisher()
    }
    
//    func getFlowModel(info : Data) -> FlowModel{
//        return FlowModel(isSuccess: false)
//    }
//    
    func convertApiToFlow<T: Decodable >(info: T) -> FlowModel {
        
        return FlowModel(isSuccess: true, message: "it's prototype")
    }
    
    func processFlow() -> AnyPublisher<FlowModel, FlowError> {
        if !onStart(){
            // return error
            return Just(FlowModel())
                .setFailureType(to: FlowError.self)
                .eraseToAnyPublisher()
        }
            
        return onExecute()
                .map{ data -> FlowModel in
                    
                    self.onEnd(info: data)
                    return data
                }
                .eraseToAnyPublisher()
        
    }
}
