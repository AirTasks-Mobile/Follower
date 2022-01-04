//
//  GetOneStake.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import Foundation
import Combine

class GetOneStake : BaseFlow {
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
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_ONE_STAKE_INFO, token: oneId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ONEResponseGetStake) -> FlowModel{
        //print("info = \(info)")
        var stakeTxn : [TransactionInfo] = []
        
        for stake in info.result ?? [] {
            //print("\(stake)")
            //print("=====")
            var doubleOne = stake.amount ?? 0
            let formattedValue = String(format: "%.12f", doubleOne / GTEXT.ONE_ROUND)
            
            doubleOne = stake.reward ?? 0
            let formattedReward = String(format: "%.12f", doubleOne / GTEXT.ONE_ROUND)
        
            let val = stake.validator_address ?? ""
            let del = stake.delegator_address ?? ""
        
            stakeTxn.append(TransactionInfo(type: GTEXT.TXN_STAKE, id: val, amt: formattedValue, src: del, des: val, date: "", fee: "", status: "", reward: formattedReward))
        }
        
        
        
        return FlowModel(isSuccess: true, transactions: stakeTxn)
    }
}
