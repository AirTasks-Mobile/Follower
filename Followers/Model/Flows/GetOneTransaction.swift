//
//  GetOneTransaction.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import Foundation
import Combine

class GetOneTransaction : BaseFlow {
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
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_ONE_ACC_INFO, token: oneId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: ONEResponseGetTransaction) -> FlowModel{
        var oneTxn : [TransactionInfo] = []
        for txn in info.result?.transactions ?? [] {
            let amt = txn.value ?? 0
            let gas = txn.gas ?? 0
            let gasPrice = txn.gasPrice ?? 0
            let fee = Double(gas) * Double(gasPrice)
    
            let formattedValue = String(format: "ONE %.12f", amt / GTEXT.ONE_ROUND)
            let formattedFee = String(format: "ONE %.12f", fee / GTEXT.ONE_ROUND)
            
            let src = txn.from ?? ""
            let des = txn.to ?? ""
            let type1 = String(format:"%d", txn.shardID ?? 0)
            let type2 = String(format:"%d", txn.toShardID ?? 0)
            let type = "shard \(type1) to \(type2)"
            
            let epochTime = txn.timestamp ?? 0
            let txnId = txn.hash ?? ""
            
            let mdate = NSDate(timeIntervalSince1970: Double(epochTime))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: mdate as Date)
            
            oneTxn.append(TransactionInfo(type: type, id: txnId, amt: formattedValue, src: src, des: des, date: localDate, fee: formattedFee, status: ""))
        }
        
        //let doubleOne = Double(info.result ?? 0)
        //let formattedValue = String(format: "%.12f", doubleOne / 1000000000000000000)
        // 9540524000000000
        return FlowModel(isSuccess: true, transactions: oneTxn)
    }
}
//0.00000001
//0.000000010000000000
