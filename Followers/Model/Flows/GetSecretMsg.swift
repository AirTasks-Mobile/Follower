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
        let gw = InfoApi(info : FlowModel(type: FLOW.GET_SECRET_MSG ,clearMsg: msg))
        return gw.connectHost()
            .map{ res -> FlowModel in
                return self.convertApiToFlow(info: res)
            }
            .eraseToAnyPublisher()
    }
    
    func convertFlowToView(info : FlowModel) -> FlowModel {
        //let isOk = info.isSuccess
        //let msg = info.message ?? ""
        
        return FlowModel(secretMsg: info.secretMsg)
    }
    
    override func getFlowModel(info: Data) -> FlowModel {
        struct S_Secret_Msg : Decodable {
            var status : String
            var secretMsg : String
        }
        
        do {
            let flowData = try JSONDecoder().decode(S_Secret_Msg.self, from: info)
            print("secret msg = \(flowData.secretMsg)")
            if flowData.status.isEmpty || flowData.status == "" {
                throw FlowError.FAIL
            }
            
            return FlowModel(isSuccess: true, secretMsg: flowData.secretMsg)
        }
        catch {
            print("catch you \(error)")
            return FlowModel(isSuccess: false)
        }
    }

}
