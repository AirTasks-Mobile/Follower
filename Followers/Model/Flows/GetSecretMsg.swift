//
//  GetSecretMsg.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 23/07/2021.
//

import Foundation
import Combine

class GetSecretMsg : BaseFlow {
    private var msg : String = ""
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        msg = viewInfo["secretMsg"] ?? ""
        if msg == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let gw = InfoApi(info : FlowModel(type: FLOW.GET_SECRET_MSG ))
        return gw.connectHost()
            .map{ res -> FlowModel in
                return self.convertApiToFlow(info: res)
            }
            .eraseToAnyPublisher()
    }
    
    
    func convertApiToFlow(info: ResInfo) -> FlowModel{

        return FlowModel(isSuccess: true, message: "a")
    }

}
