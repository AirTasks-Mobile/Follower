//
//  GetSolTransactionDetail.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import Foundation
import Combine

class GetSolTransactionDetail : BaseFlow {
    private var txnSignature : String = ""
    
    override func onStart() -> Bool {
        if viewInfo.isEmpty {
            return false
        }
        
        txnSignature = viewInfo["id"] ?? ""
        if txnSignature == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_SOL_TXN_INFO, token: txnSignature))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: SOLResponseGetTransactionDetail) -> FlowModel{
        //print("\(info.result)")
     
        let epochTime = info.result?.blockTime ?? 0
        let accounts : [String] = info.result?.transaction?.message?.accountKeys ?? [""]
        
        let fee = info.result?.meta?.fee ?? 0
        let postBal : [Int] = info.result?.meta?.postBalances ?? []
        //let preBal : [Int] = info.result?.meta?.preBalances ?? []
        //let reward = info.result?.meta?.rewards ?? []
        
        if epochTime == 0 || accounts.count < 2 || postBal.count < 2 {
            return FlowModel(isSuccess: false)
        }
        
        var doubleTemp = Double(fee)
        let formattedFee = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
        
        doubleTemp = Double(postBal[1])
        let formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
        
        var type = " "
        for acc in accounts {
            if acc == GTEXT.SOL_STAKE_ACC {
                type = GTEXT.TXN_STAKE
            }
            else if acc == GTEXT.SOL_TRANSER_ACC {
                type = GTEXT.TXN_TRANSFER
            }
        }
        
        let mdate = NSDate(timeIntervalSince1970: Double(epochTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: mdate as Date)
        
        let txn : TransactionInfo
        if type == GTEXT.TXN_STAKE {
            let stakeAcc = StakeAccountInfo(scheme: GTEXT.SOLANA, src: accounts[0], des: accounts[1], deposit: formattedAmt, date: localDate, epoch: "", fee: formattedFee)
            
            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA, stake: stakeAcc)
        }
        else {
            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA)
        }
        
        
        return FlowModel(isSuccess: true, transaction: txn)
    }
}
