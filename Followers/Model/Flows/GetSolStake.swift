//
//  GetSolStake.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import Foundation
import Combine

class GetSolStake : BaseFlow {
    private var stakeList : [String] = []
    private var stakeSol : [StakeAccountInfo] = []
    
    func setStakeList(sol : [StakeAccountInfo]) -> Void {
        stakeSol = sol
        for stake in stakeSol {
            stakeList.append(stake.des)
        }
   
    }
    
    override func onStart() -> Bool {
        if stakeList.count == 0 {
            return false
        }
        
        return true
    }
    
    override func onExecute() -> AnyPublisher<FlowModel, FlowError> {
        let connectHost = InfoApi(info: FlowModel(type: FLOW.GET_SOL_STAKE_INFO, stakes: stakeList))
        return connectHost.connectHost()
            .map { apiData -> FlowModel in
                return self.convertApiToFlow(info: apiData)
            }
            .eraseToAnyPublisher()
    }
    
    func convertApiToFlow(info: SOLResponseStake) -> FlowModel{
        if stakeSol.count != info.result.count {
            // something went wrong
            //print("Wrong !!!!!!!")
            return FlowModel(isSuccess: false)
        }
        
        var stakeTxn : [TransactionInfo] = []
        var idCount = 0
        for stake in info.result {
            var doubleSOL = Double(stake?.amount ?? 0) // 9
            let formattedReward = String(format: "%f", doubleSOL / GTEXT.SOL_ROUND)
            let formattedCommission = String(format: "%d", stake?.commission ?? 0)
            
            doubleSOL = Double(stake?.postBalance ?? 0)
            var formattedAmt : String = stakeSol[idCount].deposit
            if doubleSOL > 0 {
                formattedAmt = String(format: "%f", doubleSOL / GTEXT.SOL_ROUND)
            }
            
            
            let poc = stake?.epoch ?? 0
            var date : String = "-"
            if poc != 0 {
                date = String(format: "%d", poc)
            }
            
    
            stakeTxn.append(TransactionInfo(type: GTEXT.TXN_STAKE, id: stakeSol[idCount].des, amt: formattedAmt, src: "", des: "", date: date, fee: "", status: "", scheme: GTEXT.SOLANA, reward: formattedReward, commission: formattedCommission, stake: stakeSol[idCount]))
            
            if stakeSol.count > idCount {
                idCount += 1
            }
        }
        
        return FlowModel(isSuccess: true, transactions: stakeTxn)
    }
}
