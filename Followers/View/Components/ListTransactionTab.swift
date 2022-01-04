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
                        Text("Reward?")
                            .font(Font.custom("Avenir-black", size: 20))
                            .foregroundColor(Color.green)
                            .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
                    }
                }
            }
            
            Text("\(id)")
                .font(Font.custom("Avenir-black", size: 17))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 3, leading: 15, bottom: 5, trailing: 15))
            
            List {
                ForEach(transactions, id:\.id) { txn in
                    Section(header: Text("Amount: \(txn.amt)")
                                .font(Font.custom("Avenir-black", size: 19))
                                .foregroundColor((txn.src == id && !stake) ? Color.red : Color.green)){
                        Text("Date: \(txn.date)")
                            .font(Font.custom("Avenir-medium", size: 17))
                            .foregroundColor(Color.gray)
                        
                        if stake {
                            Text("Delegator: \(txn.src)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                            Text("Validator: \(txn.des)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                        }
                        else if txn.src == id {
                            Text("From: \(nick)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                            Text("To: \(txn.des)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                        }
                        else if txn.des == id {
                            Text("From: \(txn.src)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                            Text("To: \(nick)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                        }
                        else {
                            Text("From: \(txn.src)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                            Text("To: \(txn.des)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                        }
                        
                        if stake {
                            Text("Reward: \(txn.reward ?? "")")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.yellow)
                        }
                        else {
                            Text("Fee: \(txn.fee)")
                                .font(Font.custom("Avenir-medium", size: 17))
                                .foregroundColor(Color.gray)
                        }

                        Text("Type: \(txn.type)")
                            .font(Font.custom("Avenir-medium", size: 17))
                            .foregroundColor(Color.gray)

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
