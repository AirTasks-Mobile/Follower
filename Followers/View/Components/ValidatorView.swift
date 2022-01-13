//
//  ValidatorView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 13/01/2022.
//

import SwiftUI

struct ValidatorView: View {
    var txn : TransactionInfo = TransactionInfo.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Validator Info : ")
                .font(Font.custom("Avenir-medium", size: 19))
                .foregroundColor(Color.gray)
       
            Text("\(txn.validator?.name ?? "")  (\(txn.validator?.active ?? "unknown")-\(txn.validator?.status ?? "unknown"))")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
       
            Text("(Website)\(txn.validator?.website ?? "")")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Text("Commission: \(Utils.formatNumber(num: txn.validator?.rate ?? "") )%")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            Text("Max Commission Change: \(Utils.formatNumber(num: txn.validator?.maxRate ?? "") )%")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
           
            Text("Total Staked: \(Utils.formatNumber(num: txn.validator?.stake ?? "") )")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
      
           
            Text("(Address)\(txn.des)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
//            Divider()
//            Text("\(txn.validator?.details ?? "")")
//                .font(Font.custom("Avenir-medium", size: 15))
//                .foregroundColor(Color.gray)
        }
    }
}

struct ValidatorView_Previews: PreviewProvider {
    static var previews: some View {
        ValidatorView()
    }
}
