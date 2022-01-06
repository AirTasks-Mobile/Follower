//
//  TransactionView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 05/01/2022.
//

import SwiftUI

struct TransactionView: View {
    @Binding var srcId : String
    @Binding var nick : String
    var txn : TransactionInfo
    
    //var texxtColor : Color = Color(red: 255.0/255, green: 255.0/255, blue: 255.0/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Date: \(txn.date)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            Divider()
            if txn.src == srcId {
                Text("From: \(nick)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                Divider()
                Text("To: \(txn.des)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
            }
            else if txn.des == srcId {
                Text("From: \(txn.src)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                Divider()
                Text("To: \(nick)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
            }
            else {
                Text("From: \(txn.src)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
                Divider()
                Text("To: \(txn.des)")
                    .font(Font.custom("Avenir-medium", size: 17))
                    .foregroundColor(Color.gray)
            }
            
            Divider()

            Text("Fee: \(txn.scheme) \(txn.fee)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)
            
            Divider()

            Text("Type: \(txn.type)")
                .font(Font.custom("Avenir-medium", size: 17))
                .foregroundColor(Color.gray)

        }
        //.padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(srcId: .constant(""), nick: .constant(""),txn: TransactionInfo.default)
    }
}
