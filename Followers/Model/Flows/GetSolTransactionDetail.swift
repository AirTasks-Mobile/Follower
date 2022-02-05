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
        let postBal : [Double] = info.result?.meta?.postBalances ?? []
        let preBal : [Double] = info.result?.meta?.preBalances ?? []
        //let reward = info.result?.meta?.rewards ?? []
        
        if epochTime == 0 || accounts.count < 2 || postBal.count < 2 {
            return FlowModel(isSuccess: false)
        }
        
        var doubleTemp = Double(fee)
        let formattedFee = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
        
        let subToken : [SOLSubTokenInfo] = info.result?.meta?.postTokenBalances ?? []
        
        var listToken : [SubToken] = []
        for token in subToken {
            let mint = token.mint ?? ""
            let amountSubToken = token.uiTokenAmount?.amount ?? ""
            let dec = token.uiTokenAmount?.decimals ?? 0
            
            if mint != "" && amountSubToken != "0" {
                if dec > 0 {
                    let doubleAmt = Double(amountSubToken) ?? 0
                    let round = pow(Double(10), Double(dec))
                    let newAmtSubToken = String(format: "%f", doubleAmt / round)
                
                    listToken.append(SubToken(token_name: mint, amount: newAmtSubToken))
                }
                else {
                    listToken.append(SubToken(token_name: mint, amount: amountSubToken))
                }
            }
        }
        
        
        var type = " "
        
        if accounts.contains(GTEXT.SOL_RENT_ACC) {
            if accounts.contains(GTEXT.SOL_STAKE_ACC) {
                type = GTEXT.TXN_STAKE
            }
            else if accounts.contains(GTEXT.SOL_TOKEN_ACC){
                if accounts.count == 5 {
                    type = GTEXT.SOL_TXN_CREATE_MINT
                }
                else if accounts.count == 7 {
                    type = GTEXT.SOL_TXN_CREATE_TOKEN_ACCOUNT
                }
            }
        }
        else if accounts.contains(GTEXT.SOL_STAKE_ACC){
            type = GTEXT.TXN_UNSTAKE
        }
        else if accounts.contains(GTEXT.SOL_TRANSER_ACC) {
            type = GTEXT.TXN_TRANSFER
        }
        

        
        let mdate = NSDate(timeIntervalSince1970: Double(epochTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: mdate as Date)
        
        let txn : TransactionInfo
        //doubleTemp = Double(postBal[1])
        doubleTemp = Double(postBal[1]) - Double(preBal[1])
        var formattedAmt = ""
        
        if type == GTEXT.TXN_STAKE {
            formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
            let stakeAcc = StakeAccountInfo(scheme: GTEXT.SOLANA, src: accounts[0], des: accounts[1], deposit: formattedAmt, date: localDate, epoch: "", fee: formattedFee)
            
            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA, stake: stakeAcc)
        }
        else if type == GTEXT.TXN_UNSTAKE {
            var transactionType = ""
            doubleTemp = Double(preBal[1]) - Double(postBal[1])
            formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
      
            if doubleTemp > 0 {
                transactionType = GTEXT.TXN_STAKE_WITDRAW
                txn = TransactionInfo(type: transactionType, id: txnSignature, amt: formattedAmt, src: accounts[1], des: accounts[0], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA)
            }
            else if doubleTemp < 0 {
                transactionType = GTEXT.TXN_STAKE + "(split)"
                let newBalance =  Double(postBal[1]) - Double(preBal[1])
                formattedAmt = String(format: "%f", newBalance / GTEXT.SOL_ROUND)
                txn = TransactionInfo(type: transactionType, id: txnSignature, amt: formattedAmt, src: accounts[2], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA)
   
            }
            else {
                transactionType = GTEXT.TXN_UNSTAKE
                txn = TransactionInfo(type: transactionType, id: txnSignature, amt: formattedAmt, src: accounts[1], des: accounts[0], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA)
            }
//            txn = TransactionInfo(type: transactionType, id: txnSignature, amt: formattedAmt, src: accounts[1], des: accounts[0], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA)
        }
//        else if type == GTEXT.SOL_TXN_CREATE_TOKEN_ACCOUNT {
//            formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
//
//
//            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA, subToken: listToken)
//        }
        else {
            //doubleTemp = Double(postBal[1]) - Double(preBal[1])
            formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
            if listToken.count > 0 {
                type = "\(type) (\(listToken[0].amount ?? ""))" // test
            }
            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA, subToken: listToken)
        }
        
        
        return FlowModel(isSuccess: true, transaction: txn)
    }
}
