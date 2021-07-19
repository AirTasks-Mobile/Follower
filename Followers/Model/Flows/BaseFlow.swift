//
//  BaseFlow.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

enum FlowError : Error {
    //case SUCC
    case FAIL
    case NETWORK
    case SERVER
    case NOT_ALLOW
}

struct FlowModel {
    var isSuccess: Bool = false
    var message : String?
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
    
    func convertApiToFlow<T: Decodable >(info: T) -> FlowModel {
        
        return FlowModel(isSuccess: true, message: "it's prototype")
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
