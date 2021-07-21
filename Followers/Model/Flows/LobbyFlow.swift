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
        print("store this token \(info.token ?? "")")
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.NORMAL))
        return connectHost.connectHost()
            .map{ apiData -> FlowModel in
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
  
    override func getFlowModel(info: Data) -> FlowModel {
        struct S_LogIn : Decodable {
            var status : String
            var token : String?
        }
        let debug = String(data: info, encoding: .utf8) ?? ""
        print("data= \(debug)")
        do {
            let flowData = try JSONDecoder().decode(S_LogIn.self, from: info)
            print("token = \(flowData.token ?? "")")
            return FlowModel(isSuccess: true, token: flowData.token)
        }
        catch {
            print("catch you \(error)")
            return FlowModel(isSuccess: false)
        }
        
    }
}
