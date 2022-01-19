//
//  GetOneValidatorInfo.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 13/01/2022.
//

import Foundation
import Combine

class GetOneValidatorInfo : BaseFlow {
    private var oneId : String = ""
    private var oneTxn : TransactionInfo
    
    init(txn: TransactionInfo) {
        oneTxn = txn
        oneId = oneTxn.des
    }
    
    override func onStart() -> Bool {
        //print("id = \(oneId)")
        if oneId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_ONE_VALIDATOR_INFO, token: oneId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ONEResponseValidator) -> FlowModel{
        //print("back here ?")
        let address = info.result?.validator?.address ?? ""
        let isActive = info.result?.activeStatus ?? ""
 
        if address == "" {
            return FlowModel(isSuccess: false)
        }
        
        let stake = info.result?.totalStake ?? 0
        let formattedValue = String(format: "%f", stake / GTEXT.ONE_ROUND)
        
//        let doubleOne = Double(info.result?.eposWinningStake ?? "0") ?? 0
//        let formattedValue = String(format: "%f", doubleOne / GTEXT.ONE_ROUND)
        
        oneTxn.validator = ValidatorInfo(active: isActive, address: address, details: info.result?.validator?.details, name: info.result?.validator?.name, rate: info.result?.validator?.rate, maxRate: info.result?.validator?.maxRate,website: info.result?.validator?.website, stake: formattedValue,status: info.result?.eposStatus)
        
        return FlowModel(isSuccess: true, transaction: oneTxn)
    }
}
