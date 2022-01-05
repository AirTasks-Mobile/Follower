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
            Text("Date: \(txn.date)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()
            
            Text("Delegator: \(txn.src)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()
            
            Text("Validator: \(txn.des)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()
         
            Text("Reward: \(txn.scheme) \(txn.reward ?? "")")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.yellow)
            

//            Text("Type: \(txn.type)")
//                .font(Font.custom("Avenir-medium", size: 17))
//                .foregroundColor(Color.gray)

        }
    }
}

struct OneStakeView_Previews: PreviewProvider {
    static var previews: some View {
        OneStakeView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
