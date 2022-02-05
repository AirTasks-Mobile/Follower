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
        
        let postTokenBalances : [SOLSubTokenInfo] = info.result?.meta?.postTokenBalances ?? []
        let preTokenBalances : [SOLSubTokenInfo] = info.result?.meta?.preTokenBalances ?? []
        
        var listToken : [SubToken] = []
        for token in postTokenBalances {
            let mint = token.mint ?? ""
            let uiAmountString = token.uiTokenAmount?.uiAmountString ?? ""
            //let uiAmount = token.uiTokenAmount?.uiAmount ?? -1
            let accIndex = token.accountIndex ?? -1
            let owner = token.owner ?? ""
            
            let preTokenBal = preTokenBalances.filter(){$0.accountIndex == accIndex}
            let tokenName = getStoredTokenName(token: mint)
            let ownerName = getStoredTokenName(token: owner)
            
            if preTokenBal.count > 0 {
                let preTokenAmt = preTokenBal[0].uiTokenAmount?.uiAmount ?? 0
                let postTokenAmt = token.uiTokenAmount?.uiAmount ?? 0
                
                if postTokenAmt >= preTokenAmt {
                    let newAmtSubToken = String(format: "%f", postTokenAmt - preTokenAmt)
                    listToken.append(SubToken(token_name: tokenName, amount: "+ \(Utils.formatNumber(num: newAmtSubToken))", token_owner: ownerName, token_id: mint, token_owner_id: owner))
                }
                else {
                    let newAmtSubToken = String(format: "%f", preTokenAmt - postTokenAmt)
                    listToken.append(SubToken(token_name: tokenName, amount: "- \(Utils.formatNumber(num: newAmtSubToken))", token_owner: ownerName, token_id: mint, token_owner_id: owner))
                }
            }
            else {
                listToken.append(SubToken(token_name: tokenName, amount: "+ \(Utils.formatNumber(num: uiAmountString))", token_owner: ownerName, token_id: mint, token_owner_id: owner))
            }
            
//            let amountSubToken = token.uiTokenAmount?.amount ?? ""
//            if mint != "" && amountSubToken != "0" {
//                listToken.append(SubToken(token_name: mint, amount: uiAmount))
//
//                if uiAmount != "" {
//                    listToken.append(SubToken(token_name: mint, amount: uiAmount))
//                }
//                else {
//                    let dec = token.uiTokenAmount?.decimals ?? 0
//                    if dec > 0 {
//                        let doubleAmt = Double(amountSubToken) ?? 0
//                        let round = pow(Double(10), Double(dec))
//                        let newAmtSubToken = String(format: "%f", doubleAmt / round)
//
//                        listToken.append(SubToken(token_name: mint, amount: newAmtSubToken))
//                    }
//                    else {
//                        listToken.append(SubToken(token_name: mint, amount: amountSubToken))
//                    }
//                }
//           }
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
                else {
                    type = "Custom Transaction"
                }
            }
        }
        else if accounts.contains(GTEXT.SOL_STAKE_ACC){
            type = GTEXT.TXN_UNSTAKE
        }
        else if accounts.contains(GTEXT.SOL_TRANSER_ACC) {
            type = GTEXT.TXN_TRANSFER
        }
        else if accounts.contains(GTEXT.SOL_TOKEN_ACC){
            type = GTEXT.TXN_MINT
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

        }
        else {
            //doubleTemp = Double(postBal[1]) - Double(preBal[1])
            formattedAmt = String(format: "%f", doubleTemp / GTEXT.SOL_ROUND)
            txn = TransactionInfo(type: type, id: txnSignature, amt: formattedAmt, src: accounts[0], des: accounts[1], date: localDate, fee: formattedFee, status: "", scheme: GTEXT.SOLANA, subToken: listToken)
        }
        
        
        return FlowModel(isSuccess: true, transaction: txn)
    }
    
    func getStoredTokenName(token: String) -> String {
        let solAddressList = UserDefaults.standard.stringArray(forKey: GTEXT.SOL_LIST) ?? []
        
        for solId in solAddressList {
            if let solData = UserDefaults.standard.object(forKey: solId) as? Data {
                if let solInfo = try? JSONDecoder().decode(CoinInfo.self, from: solData){
                    if solInfo.id == token {
                        return solInfo.nick
                    }
                }
            }
        }
        
        return token
    }
}
