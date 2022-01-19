//
//  OneStakeView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI

struct OneStakeView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            Text("Delegator: \(txn.src == srcId ? nick : txn.src)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()

            ValidatorView(txn: txn)
            
            Divider()
         
            Text("Reward: \(txn.scheme) \(txn.reward ?? "")")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.yellow)
            
            Divider()
            
            ForEach(txn.stake?.unstakes ?? [], id:\.id) { unstake in
                Text("Undelegate: \(unstake.amt ?? "") at \(unstake.date ?? "")")
                    .font(Font.custom("Avenir-black", size: 15))
                    .foregroundColor(Color.gray)
            }


        }
    }
    
}

struct OneStakeView_Previews: PreviewProvider {
    static var previews: some View {
        OneStakeView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
