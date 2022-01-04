//
//  GetSolTransaction.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/01/2022.
//

import Foundation
import Combine

class GetSolTranaction : BaseFlow {
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
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_SOL_ACC_INFO, token: solId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: SOLResponeGetSignatureInfo) -> FlowModel{
        //print("\(info)")
        var txnList : [String] = []
        for txn in info.result ?? [] {
            if txn.signature != "" {
                //print("\(txn.signature)")
                txnList.append(txn.signature ?? "" )
            }
        }
        
        return FlowModel(isSuccess: true, signature: txnList)
    }
}
