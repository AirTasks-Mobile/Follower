//
//  GetXLMAccount.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 07/01/2022.
//

import Foundation
import Combine

class GetXlmAccount : BaseFlow {
    private var xlmId : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        xlmId = viewInfo["id"] ?? ""
        if xlmId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_STELLAR_ACCOUNT, token: xlmId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: XLMResponseAccount) -> FlowModel{
        //let doubleValue = Double(info.balances[0]?.balance ?? "0" ) ?? 0
        //let formattedValue = String(format: "%f", doubleValue / GTEXT.XLM_ROUND)
        //print("\(info)")
        
        let xmlBalance = info.balances[0]?.balance ?? "0"

        return FlowModel(isSuccess: true, balance: xmlBalance)
    }
}
