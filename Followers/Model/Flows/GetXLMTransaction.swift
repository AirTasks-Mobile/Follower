//
//  GetXLMTransaction.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 08/01/2022.
//

import Foundation
import Combine

class GetXLMTransaction : BaseFlow {
    private var xlmId : String = ""
    private var xlmCursor : Double = 0
    
    func setCursor(cur: Double) -> Void {
            xlmCursor = cur
    }
    
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
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_STELLAR_OPERATION, token: xlmId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: XLMResponseOperation) -> FlowModel{
        //let doubleValue = Double(info.balances[0]?.balance ?? "0" ) ?? 0
        //let formattedValue = String(format: "%f", doubleValue / GTEXT.XLM_ROUND)
        //print("\(info)")
        
        //let xmlBalance = info.balances[0]?.balance ?? "0"
        let nextPage : String = info._links?.next?.href ?? ""
        var txnList : [TransactionInfo] = []
        for txn in info._embedded?.records ?? [] {
            let txnAmt = txn.amount ?? ""
            let txnDate = txn.created_at ?? ""
            let srcAcc = txn.source_account ?? ""
            let txnId = txn.id ?? ""
            
            let txnType = txn.type ?? ""
            switch (txnType){
            case GTEXT.XLM_TYPE_PAY:
                let assetType = txn.asset_type ?? ""
                let desAcc = txn.to ?? ""
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: desAcc, date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR, reward: assetType, commission: (assetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : assetType)))
                break
            case GTEXT.XLM_TYPE_XPAY:
                let assetType = txn.asset_type ?? ""
                let desAcc = txn.to ?? ""
                let srcAssetType = txn.source_asset_type ?? ""
                let srcAssetCode = txn.source_asset_code ?? ""
                let srcAmt = txn.source_amount ?? ""
                
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: desAcc, date: txnDate, fee: (srcAssetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : srcAssetType), status: "\(srcAssetCode) \(srcAmt)", scheme: GTEXT.STELLAR, reward: assetType, commission: (assetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : assetType)))
                break
            case GTEXT.XLM_TYPE_CREATE_CLAIM:
                let asset = txn.asset ?? ""
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: "", date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR, reward: asset, commission: ""))
                
                break
            case GTEXT.XLM_TYPE_CREATE_ACCOUNT:
                let bal = txn.starting_balance ?? ""
                let desAcc = txn.account ?? ""
                
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: bal, src: srcAcc, des: desAcc, date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR))
                break
            case GTEXT.XLM_TYPE_DELETE_ACCOUNT:
                let desAcc = txn.into ?? ""
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: "", src: srcAcc, des: desAcc, date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR))
                break
            default:
                break
            }
        }

        return FlowModel(isSuccess: true, transactions: txnList)
    }
}
