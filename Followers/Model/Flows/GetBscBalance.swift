//
//  GetBscBalance.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import Foundation
import Combine

class GetBscBalance : BaseFlow {
    private var bscId : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        bscId = viewInfo["id"] ?? ""
        if bscId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_BSC_BALANCE, token: bscId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ETHResponseBalance) -> FlowModel{
        let doubleValue = Double(info.result ?? "0" ) ?? 0
        let formattedValue = String(format: "%f", doubleValue / GTEXT.ETH_ROUND)
        
        return FlowModel(isSuccess: true, balance: formattedValue)
    }
}
