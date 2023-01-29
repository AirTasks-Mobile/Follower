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
    var onAsset : () -> Void
    var textReward : String = "Stake Reward?"
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if id == "" {
                bodyEmpty
            }
            else {
                if textReward == "both"{
                    TransactionListBarSol(isLoading: $isLoading, isClick: $stake, nick: nick, id: id, isBtn: isStake, onStake: onStake, onAsset: onAsset)
                }
                else if textReward == "Stake Reward?" {
                    TransctionListBar(isLoading: $isLoading, isClick: $stake, nick: nick, id: id, isBtn: isStake, onClick: onStake)
                }
                else {
                    TransactionListBarXlm(isLoading: $isLoading, isClick: $stake, nick: nick, id: id, isBtn: isStake, onClick: onAsset, textReward: textReward)
                }
            }
            
            if transactions.count > 0 { // for iOS 14, not display staking transactions
                List {
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
                                        
                                    }
                                    
                                }
                           
                            }
                        }
                        else if txn.type == GTEXT.STELLAR || txn.type == GTEXT.SOLANA {
                            XlmAssetView(srcId: $id, nick: $nick, txn: txn)
                        }
                        else if !stake {
                            
                            Section(header: AmountView(text: "Amount: \(getAmount(txn: txn))", amt: "\(txn.amt)", isOut : isOutAmt(txn: txn)) ){
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
        } // end VStack
        
     
    }
    
    var bodyEmpty : some View {
        VStack(alignment: .center) {
            Image(systemName: "clear")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 25, height: 25, alignment: .center)
            Text("No selected coin !")
                .font(Font.custom("Avenir-meidum", size: 17))
                .foregroundColor(.gray)
        }
    }
    
    func isOutAmt(txn : TransactionInfo) -> Bool {
        return (txn.src == id)
    }
    
    func calDisplayList(index: Int) -> Void {
        
    }
    
    func getAmount(txn: TransactionInfo) -> String {
        if(txn.scheme == GTEXT.STELLAR){
            return txn.commission ?? txn.scheme
        }
        
        return txn.scheme
    }
}

struct ListTransactionTab_Previews: PreviewProvider {
    static var previews: some View {
        ListTransactionTab(nick: .constant(""), id: .constant(""), transactions: .constant([TransactionInfo.default]), isLoading: .constant(true), stake: .constant(false), isLast: .constant(false),onStake: { }, loadMore: { }, onAsset: { })
    }
}
