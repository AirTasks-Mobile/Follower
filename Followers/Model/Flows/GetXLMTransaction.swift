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
    private var xlmCursor : String = ""
    
    func setCursor(cur: String) -> Void {
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
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_STELLAR_OPERATION, token: xlmId, cursor: xlmCursor))
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
        var cursorString = getQueryStringParameter(url: nextPage, param: "cursor")
        if cursorString == xlmCursor {
            // end
            cursorString = ""
        }
        //print("next page = \(cursorString)")
        var txnList : [TransactionInfo] = []
        for txn in info._embedded?.records ?? [] {
            let txnAmt = txn.amount ?? ""
            let txnDateXml = txn.created_at ?? ""
            var txnDateF = txnDateXml.replacingOccurrences(of: "T", with: " ")
            txnDateF = txnDateF.replacingOccurrences(of: "Z", with: "")
            let txnDate = dateTimeStatus(date: txnDateF)
            let srcAcc = txn.source_account ?? ""
            let txnId = txn.id ?? ""
            
            let txnType = txn.type ?? ""
            switch (txnType){
            case GTEXT.XLM_TYPE_PAY:
                let assetType = txn.asset_type ?? ""
                let assetCode = txn.asset_code ?? ""
                let desAcc = txn.to ?? ""
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: desAcc, date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR, reward: assetType, commission: (assetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : assetCode)))
                break
            case GTEXT.XLM_TYPE_XPAY:
                let assetType = txn.asset_type ?? ""
                let assetCode = txn.asset_code ?? ""
                let desAcc = txn.to ?? ""
                let srcAssetType = txn.source_asset_type ?? ""
                let srcAssetCode = txn.source_asset_code ?? ""
                let srcAmt = txn.source_amount ?? ""
                
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: desAcc, date: txnDate, fee: (srcAssetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : srcAssetCode), status: "\(srcAssetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : srcAssetCode) \(srcAmt)", scheme: GTEXT.STELLAR, reward: assetType, commission: (assetType == GTEXT.XLM_ASSET ? GTEXT.STELLAR : assetCode)))
                break
            case GTEXT.XLM_TYPE_CREATE_CLAIM:
                let asset = txn.asset ?? ""
                let assetPair = asset.components(separatedBy: ":")
                let assetCode = assetPair[0] == GTEXT.STELLAR ? GTEXT.STELLAR : assetPair[0]
                txnList.append(TransactionInfo(type: txnType, id: txnId, amt: txnAmt, src: srcAcc, des: "", date: txnDate, fee: "", status: "", scheme: GTEXT.STELLAR, reward: asset, commission: assetCode))
                
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

        return FlowModel(isSuccess: true, transactions: txnList, cursor: cursorString)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else {
          return ""
      }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func dateTimeStatus(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: date) {
            let userFormatter = DateFormatter()
            userFormatter.dateStyle = .medium // Set as desired
            userFormatter.timeStyle = .medium // Set as desired

            return userFormatter.string(from: dt)
        } else {
            return "Unknown date"
        }
    }
}
