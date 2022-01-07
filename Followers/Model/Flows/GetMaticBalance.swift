//
//  GetMaticBalance.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import Foundation
import Combine

class GetMaticBalance : BaseFlow {
    private var maticId : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        maticId = viewInfo["id"] ?? ""
        if maticId == "" {
            return false
        }
        
        return true 
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_MATIC_BALANCE, token: maticId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ETHResponseBalance) -> FlowModel{
        let doubleValue = Double(info.result ) ?? 0
        let formattedValue = String(format: "%f", doubleValue / GTEXT.ETH_ROUND)
  
        
        return FlowModel(isSuccess: true, balance: formattedValue)
    }
}
