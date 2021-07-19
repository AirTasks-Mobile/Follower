//
//  LobbyFlow.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class LobbyFlow : BaseFlow {
    override func onStart() -> Bool {
        if viewInfo.isEmpty{
            
        }
        
        
        return true;
    }
    
    override func onEnd(info: FlowModel) {
        //
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi()
        return connectHost.connectHost()
            .map{ apiData -> FlowModel in
                // transform API format to Model format
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func processFlow() -> AnyPublisher<LobbyState, FlowError> {
        
        if !onStart(){
            // return error
           
            return Just(LobbyState(isOK: false))
                .setFailureType(to: FlowError.self)
                .eraseToAnyPublisher()
        }
        
        return onExecute()
                .map{ model -> LobbyState in
                    // process/store non-view relelated info
                    self.onEnd(info: model)
                    return self.convertFlowToView(info: model)
                }
                .eraseToAnyPublisher()
        
    }
    
    func convertFlowToView(info : FlowModel) -> LobbyState {
        let isOk = info.isSuccess
        //let msg = info.message ?? ""
       
        return LobbyState(isOK: isOk)
    }
    
    func convertApiToFlow(info: ResInfo) -> FlowModel{

        let payload = info.payload ?? ""
        let sec = info.res_sec ?? ""
        print("payload = \(payload)")
        print("sec = \(sec)")
        //let isOK = (status == APPROVED)
        
        return FlowModel(isSuccess: true)
    }
}
