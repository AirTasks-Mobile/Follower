//
//  XlmAssetView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 12/01/2022.
//

import SwiftUI

struct XlmAssetView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    var body: some View {
        HStack(spacing: 0){
            Text(" \(txn.scheme) ")
                .font(Font.custom("Avenir-medium", size: 15))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Text(" \(Utils.formatNumber(num: txn.amt)) ")
                .font(Font.custom("Avenir-medium", size: 15))
                .foregroundColor(Color.green)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            
            Spacer()
        }
    }
    
    
}

struct XlmAssetView_Previews: PreviewProvider {
    static var previews: some View {
        XlmAssetView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
