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
    
    var secretMsg : String?
    var clearMsg : String?
    
    var pigeon : [String:String]?
    var sparrows : [String:String]?
    var oStates : [String: String]?
    var vStates : [String:String]?
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
        print("onStart")
        return true
    }
    
    func onEnd(info: FlowModel) {
        print("onEnd")
    }
    
    func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        return Just(FlowModel())
            .setFailureType(to: FlowError.self)
            .eraseToAnyPublisher()
    }
    
//    func convertApiToFlow<T: Decodable >(info: T) -> FlowModel {
//
//        return FlowModel(isSuccess: true, message: "it's prototype")
//    }
    func getFlowModel(info : Data) -> FlowModel{
        return FlowModel(isSuccess: false)
    }
    
    func convertApiToFlow(info: ResInfo) -> FlowModel{

        let payload = info.payload ?? ""
        //let sec = info.res_sec ?? ""
        //print("payload = \(payload)")
        //print("sec = \(sec)")
        //let isOK = (status == APPROVED)
        
        let data = Data(payload.utf8)
        
        //let info = try?JSONDecoder().decode(S_Clear_Msg.self, from: data)
       // print("clear msg = \(info?.clearMsg ?? "")")
        
        return getFlowModel(info: data)
    }
    
    func processFlowTemplate() -> AnyPublisher<Int, FlowError> {
        if !onStart(){
            // return error
            return Just(0)
                .setFailureType(to: FlowError.self)
                .eraseToAnyPublisher()
        }
            
        return onExecute()
                .map{ data -> Int in
                    self.onEnd(info: data)
                    
                    return 0
                }
                .eraseToAnyPublisher()
        
    }
}
