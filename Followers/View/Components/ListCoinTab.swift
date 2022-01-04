//
//  ListCoinTab.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/01/2022.
//

import SwiftUI

struct ListCoinTab: View {
    @Binding var listCoin : [CoinInfo]
    @Binding var selectedCoin : CoinInfo
    var onAddCoin : () -> Void
    var onDetail : () -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(listCoin, id: \.id) { sol in
                Button(action: {
                    onClickDetail(sol: sol)
                }){
                    CoinTag(oneCoin: sol, name: "dollarsign.circle")
                        .frame(height: 95)
                }
                //Spacer()
            }
            
            Button(action: onAddCoin ){
            CoinTag(oneCoin: CoinInfo(type: "", id: "Click To Add New Coin !", nick: "", pic: "", bal: "", date: ""), name: "rectangle.stack.fill.badge.plus")
                .frame(height: 95)
            }
        }
        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
    }
    
    func onClickDetail(sol : CoinInfo) -> Void {
        //print("click = \(sol.nick)")
        selectedCoin = sol
        onDetail()
    }
}

struct ListCoinTab_Previews: PreviewProvider {
    static var previews: some View {
        ListCoinTab(listCoin: .constant([CoinInfo.default]), selectedCoin: .constant(CoinInfo.default),onAddCoin: { }, onDetail: { })
    }
}
