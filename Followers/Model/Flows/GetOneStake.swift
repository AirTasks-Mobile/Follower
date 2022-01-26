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
        let stakeResult = info.result ?? []
        if stakeResult.count == 0 {
            return FlowModel(isSuccess: false)
        }
        
        for stake in stakeResult.reversed() {
            //print("\(stake)")
            //print("=====") 12
            var doubleOne = stake.amount ?? 0
            let formattedValue = String(format: "%f", doubleOne / GTEXT.ONE_ROUND)
            
            let doubleOneReward = stake.reward ?? 0
            let formattedReward = String(format: "%f", doubleOneReward / GTEXT.ONE_ROUND)
            
            if doubleOne == 0 && doubleOneReward == 0 {
                continue
            }
        
            let val = stake.validator_address ?? ""
            let del = stake.delegator_address ?? ""
            
            let unstake = stake.Undelegations
            var unstakeCount = 0
            if unstake.count > 0 {
                var unstakeList : [UnStakeInfo] = []
                for rev in unstake {
                    unstakeCount += 1
                    doubleOne = rev?.Amount ?? 0
                    let formattedUnStakeAmt = String(format: "%f", doubleOne / GTEXT.ONE_ROUND)
                    unstakeList.append(UnStakeInfo(id: "\(unstakeCount)", amt: formattedUnStakeAmt, date: "epoch \(rev?.Epoch ?? 0)"))
                }
                
                stakeTxn.append(TransactionInfo(type: GTEXT.TXN_STAKE_REWARD, id: val, amt: formattedValue, src: del, des: val, date: "", fee: "", status: "", scheme: GTEXT.HARMONY,reward: formattedReward, stake: StakeAccountInfo(scheme: GTEXT.HARMONY, src: "", des: "", deposit: "", date: "", epoch: "", fee: "", unstakes: unstakeList)))
            }
            else {
                stakeTxn.append(TransactionInfo(type: GTEXT.TXN_STAKE_REWARD, id: val, amt: formattedValue, src: del, des: val, date: "", fee: "", status: "", scheme: GTEXT.HARMONY,reward: formattedReward))
            }
        }
        
        return FlowModel(isSuccess: true, transactions: stakeTxn)
    }
}
