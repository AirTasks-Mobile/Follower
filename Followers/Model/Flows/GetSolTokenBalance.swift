//
//  GetSolTokenBalance.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/02/2022.
//

import Foundation
import Combine

class GetSolTokenBalance : BaseFlow {
    private var solTokenId : String = ""
    private var asset : AssetInfo
    
    init(asset: AssetInfo) {
        self.asset = asset
    }
    override func onStart() -> Bool {
        solTokenId = asset.code
        if solTokenId == "" {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_SOL_TOKEN_BALANCE, token: solTokenId))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    //

    func convertApiToFlow(info: SOLResponeGetTokenBalance) -> FlowModel{
        let bal = info.result?.value?.uiAmountString ?? ""
        
        if bal == "" {
            return FlowModel(isSuccess: false)
        }
        
        let txnId = asset.code + asset.type
        
        return FlowModel(isSuccess: true, transaction: TransactionInfo(type: GTEXT.SOLANA, id: txnId, amt: bal, src: "", des: "", date: "", fee: "", status: "", scheme: asset.type))
    }
}
