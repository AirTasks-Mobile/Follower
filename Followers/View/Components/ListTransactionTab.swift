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
    @Binding var isLoading : Bool
    @Binding var stake : Bool
    @Binding var isLast : Bool
    var isStake : Bool = false
    var onStake : () -> Void
    var loadMore : () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0){
                Text("\(nick)")
                    .font(Font.custom("Avenir-black", size: 19))
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                if isStake && !stake {
                    if isLoading {
                        ActivityIndicator()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 0.9))
                    }
                    else {
                    Button(action: {
                        if !stake {
                            onStake()
                            stake = true
                        }
                    }){
                        Spacer()
                        Text(" Stake Reward? ")
                            .font(Font.custom("Avenir-black", size: 20))
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color.yellow, lineWidth: 1)
                            )
                            .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
                    }
                    
                    }// loading
                }
                else if isLoading {
                    ActivityIndicator()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 0.9))
                }
            }
            
            Text("\(id)")
                .font(Font.custom("Avenir-black", size: 15))
                .foregroundColor(Color.gray)
                .padding(EdgeInsets(top: 3, leading: 15, bottom: 5, trailing: 15))
            
            if transactions.count > 0 { // for iOS 14, not display staking transactions
                List {
//                    Text(" ")
//                        .font(Font.custom("Avenir-medium", size: 1))
//                        .onAppear(perform: {
//                            print("at list beggining")
//                        })
                    ForEach(transactions, id:\.id) { txn in
                        if txn.type == GTEXT.TXN_STAKE_REWARD {
                            Section(header: AmountView(text: "Balance: \(txn.scheme)", amt: "\(txn.amt)", isOut : false) ){
                                if stake {
                                    if txn.scheme == GTEXT.SOLANA {
                                        SolStakeView(srcId: $id, nick: $nick, txn: txn)
                                    }
                                    else if txn.scheme == GTEXT.HARMONY {
                                        OneStakeView(srcId: $id, nick: $nick, txn: txn)
                                    }
                                    else {
                                        //Text(" ??? ")
                                    }
                                    
                                }
                           
                            }
                        }
                        else if !stake {
                            
                            Section(header: AmountView(text: "Amount: \(txn.scheme)", amt: "\(txn.amt)", isOut : isOutAmt(txn: txn)) ){
                                if txn.scheme == GTEXT.STELLAR {
                                    XLMTransactionView(srcId: $id, nick: $nick, txn: txn)
                                }
                                else {
                                    TransactionView(srcId: $id, nick: $nick, txn: txn)
                                }
                            }
                        
                        }
                        
                    } // end foreach
                    if !isLast && !isLoading {
                        HStack {
                            Spacer()
                            ActivityIndicator()
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 1.0))
                            Spacer()
                        }
                        .onAppear(perform: {
                            //print("count = \(transactions.count)")
                            // iOS 14 (tested iOS 14.3) only work if user already scrolled and waited at end of the list
                            // iOS 15 supports from iphone6S, so no need to fix this :)
                            loadMore()
                        })
                    }
            
                } // End List
            }
            else {
                Spacer()
                Spacer()
            }
        }
    }
    
    func isOutAmt(txn : TransactionInfo) -> Bool {
//        if txn.scheme == GTEXT.STELLAR {
//
//        }
//        else {
//            return (txn.src == id)
//        }
        
        return (txn.src == id)
    }
    
    func calDisplayList(index: Int) -> Void {
        
    }
}

struct ListTransactionTab_Previews: PreviewProvider {
    static var previews: some View {
        ListTransactionTab(nick: .constant(""), id: .constant(""), transactions: .constant([TransactionInfo.default]), isLoading: .constant(true), stake: .constant(false), isLast: .constant(false),onStake: { }, loadMore: { })
    }
}
