//
//  GetClearMsg.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import Foundation
import Combine

class GetClearMsg : BaseFlow {
    private var msg : String = ""
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        msg = viewInfo["clearMsg"] ?? ""
        if msg == "" {
            return false
        }
        
        return true
    }
    
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let gw = InfoApi(info : FlowModel(type: FLOW.GET_CLEAR_MSG ,secretMsg: msg))
        return gw.connectHost()
            .map{ res -> FlowModel in
                return self.convertApiToFlow(info: res)
            }
            .eraseToAnyPublisher()
    }
    
    func convertFlowToView(info : FlowModel) -> HomeState {
        //let isOk = info.isSuccess
        //let msg = info.message ?? ""
        
        return HomeState(clearMsg: info.clearMsg)
    }
    
    override func getFlowModel(info: Data) -> FlowModel {
        struct S_Clear_Msg : Decodable {
            var status : String
            var clearMsg : String
        }
        
        do {
            let flowData = try JSONDecoder().decode(S_Clear_Msg.self, from: info)
            print("clear msg = \(flowData.clearMsg)")
            if flowData.status.isEmpty || flowData.status == "" {
                throw FlowError.FAIL
            }
            
            return FlowModel(isSuccess: true, clearMsg: flowData.clearMsg)
        }
        catch {
            print("catch you \(error)")
            return FlowModel(isSuccess: false)
        }
    }
    
    func processFlow() -> AnyPublisher<HomeState, FlowError> {
        if !onStart() {
            return Just(HomeState(clearMsg: "[error]"))
                .setFailureType(to: FlowError.self)
                .eraseToAnyPublisher()
        }
        
        return onExecute()
            .map { res -> HomeState in
                self.onEnd(info: res)
                return self.convertFlowToView(info: res)
            }
            .eraseToAnyPublisher()
    }
}
