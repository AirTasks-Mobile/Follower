//
//  ListTransactionTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/01/2022.
//

import SwiftUI

struct ListTransactionTab: View {
    @Binding var nick : String
    @Binding var id : String
    @Binding var transactions : [TransactionInfo]
    var isStake : Bool = false
    @State var stake : Bool = false
    var onStake : () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0){
                Text("\(nick)")
                    .font(Font.custom("Avenir-black", size: 19))
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
                if isStake {
                    Button(action: {
                        if !stake {
                            onStake()
                            stake = true
                        }
                    }){
                        Spacer()
                        Text("Stake Reward?")
                            .font(Font.custom("Avenir-black", size: 20))
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color.yellow, lineWidth: 1)
                            )
                            .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
                    }
                }
            }
            
            Text("\(id)")
                .font(Font.custom("Avenir-black", size: 15))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 3, leading: 15, bottom: 5, trailing: 15))
            //(text: (isStake ? "Balance" : "Amount"), amt: txn.amt, isOut : (txn.src == id && !stake))
            List {
                ForEach(transactions, id:\.id) { txn in
                    Section(header: AmountView(text: (stake ? "Balance" : "Amount"), amt: "\(txn.scheme) \(txn.amt)", isOut : (txn.src == id && !stake)) ){
                        if stake {
                            if txn.scheme == GTEXT.SOLANA {
                                SolStakeView(srcId: $id, nick: $nick, txn: txn)
                            }
                            else if txn.scheme == GTEXT.HARMONY {
                                OneStakeView(srcId: $id, nick: $nick, txn: txn)
                            }
                        }
                        else {
                            TransactionView(srcId: $id, nick: $nick, txn: txn)
                        }


                    }

                }
        
            }
            .listRowBackground(Color.clear)
            .onDisappear(perform: {
                stake = false
            })
            
            
        }
    }
}

struct ListTransactionTab_Previews: PreviewProvider {
    static var previews: some View {
        ListTransactionTab(nick: .constant(""), id: .constant(""), transactions: .constant([TransactionInfo.default]), onStake: { })
    }
}
