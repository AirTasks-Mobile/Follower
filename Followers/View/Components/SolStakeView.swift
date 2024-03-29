//
//  SolStakeView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI

struct SolStakeView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            BodyDeposit
            Divider()
            
            Text("Deposit Date: \(txn.stake?.date ?? "")")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()
            
            Text("Stake Account : \(txn.id)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
            
            Divider()
            
            Text("Commission: \(txn.commission ?? "")%")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()
            
            Text("Last Reward: \(txn.scheme) \(txn.reward ?? "")")
                    .font(Font.custom("Avenir-black", size: 17))
                    .foregroundColor(Color.yellow)
            
            Text("Last Reward Date : epoch \(txn.date)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)

        }
    }
    
    var BodyDeposit: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Deposit: \(txn.scheme) \(txn.stake?.deposit ?? "")")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
            
            Divider()
  
            Text("Deposit Fee: \(txn.scheme) \(txn.stake?.fee ?? "")")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
        }
    }
}

struct SolStakeView_Previews: PreviewProvider {
    static var previews: some View {
        SolStakeView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
