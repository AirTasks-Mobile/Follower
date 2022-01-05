//
//  GetOneBalance.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import Foundation
import Combine

class GetOneBalance : BaseFlow {
    private var oneId : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        oneId = viewInfo["id"] ?? ""
        if oneId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_ONE_BALANCE, token: oneId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ONEResponseGetBalance) -> FlowModel{
        //print("info = \(info)")
        let doubleOne = Double(info.result ?? 0)
        let formattedValue = String(format: "%f", doubleOne / GTEXT.ONE_ROUND)
        
        return FlowModel(isSuccess: true, balance: formattedValue)
    }
}

//2 298724803487127976
