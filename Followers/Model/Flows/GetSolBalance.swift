//
//  GetSolBalance.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 02/01/2022.
//

import Foundation
import Combine


class GetSolBalance : BaseFlow {
    private var solId : String = ""
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        solId = viewInfo["id"] ?? ""
        if solId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_SOL_BALANCE, token: solId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    //

    func convertApiToFlow(info: SOLResponeGetBalance) -> FlowModel{
        let doubleSOL = Double(info.result.value ?? 0)
        let formattedValue = String(format: "%.9f", doubleSOL / GTEXT.SOL_ROUND)
        
        return FlowModel(isSuccess: true, balance: formattedValue)
    }
    
//    func convertApiToFlow(info: SOLResponeMulAcc) -> FlowModel{
    // production doesn't work
    // devnet return null for some accounts
//        //print("--->> \(info.result?.value)")
//        print("---->>>> ")
//        var formattedValue : String = ""
//        for solValue in info.result?.value ?? [] {
//            let doubleSOL = Double(solValue.lamports ?? 0)
//            formattedValue = String(format: "SOL %.9f", doubleSOL / 1000000000)
//
//            print("SOL = \(formattedValue)")
//        }
//        //let doubleSOL = Double(info.value?[0].lamports ?? 0)
//        //let formattedValue = String(format: "SOL %.9f", doubleSOL / 1000000000)
//
//
//
//        return FlowModel(isSuccess: true, balance: formattedValue)
//    }
}
